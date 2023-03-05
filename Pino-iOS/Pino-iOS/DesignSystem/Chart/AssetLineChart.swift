//
//  PinoLineChart.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/5/23.
//

import Charts
import Combine
import UIKit

class AssetLineChart: UIView {
	// MARK: - Private Properties

	private let balanceStackview = UIStackView()
	private let infoStackView = UIStackView()
	private let chartStackView = UIStackView()
	private let volatilityStackView = UIStackView()
	private let coinBalanceLabel = UILabel()
	private let coinVolatilityPersentage = UILabel()
	private let coinVolatilityInDollor = UILabel()
	private let dateLabel = UILabel()
	private let chartPointer = UIImageView()
	private var chartDateFilter: UISegmentedControl!

	private let lineChartView = PinoLineChart(chartDataEntries: [])
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
		self.chartDateFilter = UISegmentedControl(items: chartVM.dateFilters.map { $0.rawValue })
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
		chartStackView.addArrangedSubview(chartDateFilter)
		addSubview(chartStackView)
		addSubview(chartPointer)
	}

	private func setupStyle() {
		chartPointer.image = UIImage(systemName: "circle.fill")
		chartPointer.tintColor = .Pino.primary
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

		chartDateFilter.pin(
			.horizontalEdges(padding: 16),
			.fixedHeight(35)
		)

		chartPointer.pin(
			.fixedWidth(10),
			.fixedHeight(10)
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

			self.lineChartView.chartDataEntries = chart.chartDataEntry
		}.store(in: &cancellables)
	}

	@objc
	private func updateChart(sender: UISegmentedControl) {
		dateFilterChanged(chartVM.dateFilters[sender.selectedSegmentIndex])
	}
}
