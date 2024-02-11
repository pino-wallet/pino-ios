//
//  PinoLineChart.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Combine
import DGCharts
import Foundation
import UIKit

class AssetLineChart: UIView, LineChartDelegate {
	// MARK: - Private Properties

	private let balanceStackview = UIStackView()
	private let contentStackView = UIStackView()
	private let infoStackView = UIStackView()
	private let chartStackView = UIStackView()
	private let volatilityStackView = UIStackView()
	private let coinBalanceLabel = UILabel()
	private let coinVolatilityPersentage = UILabel()
	private let coinVolatilityInDollor = UILabel()
	private let dateLabel = UILabel()
	private let chartPointer = UIImageView()
	private let loadingGradientView = UIView()
	private var loadingGradientLayer: GradientLayer!
	private var chartDateFilter: UISegmentedControl!
	private let dateFilters: [ChartDateFilter] = [.day, .week, .month, .year, .all]

	private let lineChartView = PinoLineChart(chartDataEntries: [])
	private var chartDataSet: LineChartDataSet!
	private var cancellables = Set<AnyCancellable>()
	private var dateFilterChanged: (ChartDateFilter) -> Void

	// MARK: - Public Properties

	@Published
	public var chartVM: AssetChartViewModel?

	// MARK: Initializers

	init(chartVM: AssetChartViewModel?, dateFilterChanged: @escaping (ChartDateFilter) -> Void) {
		self.chartVM = chartVM
		self.dateFilterChanged = dateFilterChanged
		self.chartDateFilter = UISegmentedControl(items: dateFilters.map { $0.rawValue })
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
		balanceStackview.addArrangedSubview(coinBalanceLabel)
		balanceStackview.addArrangedSubview(volatilityStackView)
		volatilityStackView.addArrangedSubview(coinVolatilityPersentage)
		volatilityStackView.addArrangedSubview(dateLabel)
		infoStackView.addArrangedSubview(balanceStackview)
		contentStackView.addArrangedSubview(infoStackView)
		contentStackView.addArrangedSubview(chartStackView)
		chartStackView.addArrangedSubview(lineChartView)
		chartStackView.addArrangedSubview(chartDateFilter)
		addSubview(contentStackView)
		addSubview(loadingGradientView)
		addSubview(chartPointer)
	}

	private func setupStyle() {
		chartPointer.image = UIImage(systemName: "circle.fill")
		chartPointer.tintColor = .Pino.primary
		coinBalanceLabel.textColor = .Pino.label
		coinVolatilityInDollor.textColor = .Pino.secondaryLabel
		dateLabel.textColor = .Pino.gray2

		coinBalanceLabel.font = .PinoStyle.semiboldTitle1
		coinVolatilityInDollor.font = .PinoStyle.mediumSubheadline
		coinVolatilityPersentage.font = .PinoStyle.mediumSubheadline
		dateLabel.font = .PinoStyle.mediumSubheadline

		coinBalanceLabel.adjustsFontSizeToFitWidth = true
		dateLabel.textAlignment = .right

		contentStackView.axis = .vertical
		chartStackView.axis = .vertical
		infoStackView.axis = .horizontal
		balanceStackview.axis = .vertical
		volatilityStackView.axis = .horizontal

		volatilityStackView.alignment = .center
		balanceStackview.alignment = .leading
		contentStackView.alignment = .center
		infoStackView.alignment = .top

		contentStackView.spacing = 24
		volatilityStackView.spacing = 8
		balanceStackview.spacing = 8
		infoStackView.spacing = 8

		chartDateFilter.setTitleTextAttributes([
			.foregroundColor: UIColor.Pino.secondaryLabel,
			.font: UIFont.PinoStyle.mediumCaption1!,
		], for: .normal)
		chartDateFilter.setTitleTextAttributes([
			.foregroundColor: UIColor.Pino.primary,
			.font: UIFont.PinoStyle.semiboldCaption1!,
		], for: .selected)
		chartDateFilter.setDividerImage(
			UIImage(),
			forLeftSegmentState: .normal,
			rightSegmentState: .normal,
			barMetrics: .default
		)
		chartDateFilter.setBackgroundImage(
			UIImage(named: "segmented_control_background"),
			for: .normal,
			barMetrics: .default
		)
		chartDateFilter.setBackgroundImage(
			UIImage(named: "segmented_control_selected_background"),
			for: .selected,
			barMetrics: .default
		)
		chartDateFilter.layer.maskedCorners = []
		chartDateFilter.selectedSegmentIndex = 0
		chartDateFilter.addTarget(self, action: #selector(updateChart), for: .valueChanged)

		chartPointer.isHidden = true

		coinVolatilityPersentage.layer.masksToBounds = true
		coinBalanceLabel.layer.masksToBounds = true

		coinBalanceLabel.isSkeletonable = true
		coinVolatilityPersentage.isSkeletonable = true

		lineChartView.chartDelegate = self

		showLoading()
	}

	private func setupCostraints() {
		contentStackView.pin(
			.horizontalEdges,
			.top(padding: 16),
			.bottom
		)
		infoStackView.pin(
			.horizontalEdges(padding: 16)
		)
		chartStackView.pin(
			.horizontalEdges
		)
		lineChartView.pin(
			.horizontalEdges
		)

		chartDateFilter.pin(
			.horizontalEdges(padding: 16),
			.fixedHeight(35)
		)
		chartPointer.pin(
			.fixedWidth(10),
			.fixedHeight(10)
		)
		loadingGradientView.pin(
			.horizontalEdges(to: lineChartView),
			.top(to: lineChartView),
			.bottom(to: lineChartView, padding: 40)
		)
		NSLayoutConstraint.activate([
			coinBalanceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
			coinBalanceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
			coinVolatilityPersentage.widthAnchor.constraint(greaterThanOrEqualToConstant: 35),
			coinVolatilityPersentage.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
		])
	}

	private func setupBindings() {
		$chartVM.sink { chart in
			if let chart {
				self.reloadChartData(chart)
				self.coinVolatilityPersentage.layer.cornerRadius = 0
				self.coinBalanceLabel.layer.cornerRadius = 0
			} else {
				self.coinVolatilityPersentage.layer.cornerRadius = 8
				self.coinBalanceLabel.layer.cornerRadius = 12
			}
		}.store(in: &cancellables)
	}

	private func showLoading() {
		showSkeletonView()
		lineChartView.showLoading()
		loadingGradientView.alpha = 0.8
		chartDateFilter.isEnabled = false
		dateLabel.isHiddenInStackView = true
	}

	private func reloadChartData(_ chart: AssetChartViewModel) {
		coinBalanceLabel.text = chart.balance
		coinVolatilityPersentage.text = chart.volatilityPercentage
		dateLabel.text = chart.chartDate
		updateVolatilityColor(type: chart.volatilityType)
		lineChartView.chartDataEntries = chart.chartDataEntry
		hideSkeletonView()
		loadingGradientView.alpha = 0
		chartDateFilter.isEnabled = true
		dateLabel.isHiddenInStackView = false
	}

	@objc
	private func updateChart(sender: UISegmentedControl) {
		showLoading()
		let dateFilter = dateFilters[sender.selectedSegmentIndex]
		dateFilterChanged(dateFilter)
	}

	private func updateVolatility(pointValue: Double, previousValue: Double?) {
		guard let chartVM else { return }
		let valueChangePercentage = chartVM.valueChangePercentage(pointValue: pointValue, previousValue: previousValue)
		coinVolatilityPersentage.text = chartVM.formattedVolatility(valueChangePercentage)
		updateVolatilityColor(type: chartVM.volatilityType(valueChangePercentage))
	}

	private func updateVolatilityColor(type: AssetVolatilityType) {
		switch type {
		case .profit:
			coinVolatilityPersentage.textColor = .Pino.green
		case .loss:
			coinVolatilityPersentage.textColor = .Pino.red
		case .none:
			coinVolatilityPersentage.textColor = .Pino.secondaryLabel
		}
	}

	private func addLoadingGradient() {
		loadingGradientLayer?.removeFromSuperlayer()
		loadingGradientLayer = GradientLayer(
			frame: loadingGradientView.bounds,
			colors: [.Pino.clear, .Pino.secondaryBackground],
			startPoint: CGPoint(x: 0, y: 0.5),
			endPoint: CGPoint(x: 1, y: 0.5)
		)
		loadingGradientView.layer.addSublayer(loadingGradientLayer)
	}

	// MARK: - Public Methods

	public func updateChartDate(date: Double) {
		let formattedDate = chartVM?.selectedDate(timeStamp: date)
		dateLabel.text = formattedDate
	}

	// MARK: - Internal Methods

	override func layoutSubviews() {
		super.layoutSubviews()
		addLoadingGradient()
	}

	internal func valueDidChange(pointValue: Double?, previousValue: Double?, date: Double?) {
		guard let chartVM else { return }
		if let pointValue {
			coinBalanceLabel.text = BigNumber(numberWithDecimal: pointValue.description)!.chartPriceFormat
			updateVolatility(pointValue: pointValue, previousValue: previousValue)
			updateChartDate(date: date!)
		} else {
			coinBalanceLabel.text = chartVM.balance
			coinVolatilityPersentage.text = chartVM.volatilityPercentage
			updateVolatilityColor(type: chartVM.volatilityType)
			dateLabel.text = chartVM.chartDate
		}
	}
}
