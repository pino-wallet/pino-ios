//
//  LineChart.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/20/23.
//

import Charts
import Combine
import UIKit

class LineChart: UIView {
	// MARK: - Private Properties

	private let balanceStackview = UIStackView()
	private let infoStackView = UIStackView()
	private let chartStackView = UIStackView()
	private let volatilityStackView = UIStackView()
	private let coinBalanceLabel = UILabel()
	private let coinVolatilityPersentage = UILabel()
	private let coinVolatilityInDollor = UILabel()
	private let dateLabel = UILabel()
	private let lineChartView = LineChartView()
	private var chartSegmentedControl: UISegmentedControl!

	private var chartDataSet: LineChartDataSet!
	private var cancellables = Set<AnyCancellable>()
	private var dateFilterChanged: (ChartDateFilter) -> Void

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel

	// MARK: Initializers

	init(chartVM: AssetChartViewModel, dateFilterChanged: @escaping (ChartDateFilter) -> Void) {
		self.chartVM = chartVM
		self.dateFilterChanged = dateFilterChanged
		self.chartSegmentedControl = UISegmentedControl(items: chartVM.dateFilters.map { $0.rawValue })
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupCostraints()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		volatilityStackView.addArrangedSubview(coinVolatilityInDollor)
		volatilityStackView.addArrangedSubview(coinVolatilityPersentage)
		balanceStackview.addArrangedSubview(coinBalanceLabel)
		balanceStackview.addArrangedSubview(volatilityStackView)
		infoStackView.addArrangedSubview(balanceStackview)
		infoStackView.addArrangedSubview(dateLabel)
		chartStackView.addArrangedSubview(infoStackView)
		chartStackView.addArrangedSubview(lineChartView)
		chartStackView.addArrangedSubview(chartSegmentedControl)
		addSubview(chartStackView)
		chartDataSet = LineChartDataSet(entries: chartVM.chartDataEntry)
		lineChartView.delegate = self
	}

	private func setupStyle() {
		setupLineChart()

		coinBalanceLabel.textColor = .Pino.label
		coinVolatilityInDollor.textColor = .Pino.secondaryLabel
		dateLabel.textColor = .Pino.secondaryLabel

		coinBalanceLabel.font = .PinoStyle.semiboldTitle1
		coinVolatilityInDollor.font = .PinoStyle.mediumSubheadline
		coinVolatilityPersentage.font = .PinoStyle.mediumSubheadline
		dateLabel.font = .PinoStyle.mediumSubheadline

		chartStackView.axis = .vertical
		infoStackView.axis = .horizontal
		balanceStackview.axis = .vertical
		volatilityStackView.axis = .horizontal

		volatilityStackView.alignment = .center
		balanceStackview.alignment = .leading
		chartStackView.alignment = .center
		infoStackView.alignment = .top

		volatilityStackView.spacing = 8
		balanceStackview.spacing = 8

		chartSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.Pino.secondaryLabel], for: .normal)
		chartSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.Pino.primary], for: .selected)
		chartSegmentedControl.setDividerImage(
			UIImage(),
			forLeftSegmentState: .normal,
			rightSegmentState: .normal,
			barMetrics: .default
		)
		chartSegmentedControl.setBackgroundImage(
			UIImage(named: "segmented_control_background"),
			for: .normal,
			barMetrics: .default
		)
		chartSegmentedControl.setBackgroundImage(
			UIImage(named: "segmented_control_selected_background"),
			for: .selected,
			barMetrics: .default
		)
		chartSegmentedControl.layer.maskedCorners = []
		chartSegmentedControl.selectedSegmentIndex = 0
		chartSegmentedControl.addTarget(self, action: #selector(updateChart), for: .valueChanged)
	}

	public func setupCostraints() {
		chartStackView.pin(
			.horizontalEdges,
			.top(padding: 16),
			.bottom
		)
		infoStackView.pin(
			.horizontalEdges(padding: 16)
		)
		lineChartView.pin(
			.horizontalEdges
		)
		dateLabel.pin(
			.relative(.centerY, 0, to: coinBalanceLabel, .centerY)
		)

		chartSegmentedControl.pin(
			.horizontalEdges(padding: 16),
			.fixedHeight(35)
		)
	}

	private func setupBindings() {
		$chartVM.sink { chart in
			self.coinBalanceLabel.text = chart.balance
			self.coinVolatilityPersentage.text = chart.volatilityPercentage
			self.coinVolatilityInDollor.text = chart.volatilityInDollor
			self.dateLabel.text = chart.chartDate
			switch chart.volatilityType {
			case .profit:
				self.coinVolatilityPersentage.textColor = .Pino.green
			case .loss:
				self.coinVolatilityPersentage.textColor = .Pino.red
			case .none:
				self.coinVolatilityPersentage.textColor = .Pino.secondaryLabel
			}

		}.store(in: &cancellables)
	}

	private func setupLineChart() {
		lineChartView.drawGridBackgroundEnabled = false
		chartDataSet.setColor(.Pino.green3)

		chartDataSet.drawCirclesEnabled = false
		chartDataSet.lineWidth = 2
		chartDataSet.mode = .cubicBezier
		chartDataSet.fillAlpha = 0.5
		if let chartGradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [UIColor.Pino.lightBlue.cgColor, UIColor.Pino.secondaryBackground.cgColor] as CFArray,
			locations: [1, 0]
		) {
			chartDataSet.fill = LinearGradientFill(gradient: chartGradient, angle: 90)
		}
		chartDataSet.drawFilledEnabled = true
		chartDataSet.highlightColor = .Pino.green2
		chartDataSet.drawCircleHoleEnabled = false
		chartDataSet.highlightEnabled = true
		lineChartView.xAxis.drawGridLinesEnabled = false
		lineChartView.leftAxis.drawGridLinesEnabled = false
		lineChartView.rightAxis.drawGridLinesEnabled = false
		lineChartView.xAxis.drawAxisLineEnabled = false
		lineChartView.leftAxis.drawAxisLineEnabled = false
		lineChartView.rightAxis.drawAxisLineEnabled = false
		lineChartView.legend.enabled = false
		lineChartView.data = LineChartData(dataSets: [chartDataSet])

		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
		longPressGesture.allowableMovement = 50
		lineChartView.addGestureRecognizer(longPressGesture)
	}

	@objc
	private func longPressDetected() {}

	@objc
	private func updateChart(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			dateFilterChanged(.hour)
		case 1:
			dateFilterChanged(.day)
		case 2:
			dateFilterChanged(.week)
		case 3:
			dateFilterChanged(.month)
		case 4:
			dateFilterChanged(.year)
		case 5:
			dateFilterChanged(.all)
		default: break
		}
	}
}

extension LineChart: ChartViewDelegate {}
