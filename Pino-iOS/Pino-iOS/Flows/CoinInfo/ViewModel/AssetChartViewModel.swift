//
//  AssetChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import DGCharts
import Foundation

struct AssetChartViewModel {
	// MARK: - Public Properties

	public let chartDataVM: [AssetChartDataViewModel]
	public var dateFilter: ChartDateFilter

	public var chartDataEntry: [ChartDataEntry] {
		chartDataVM.map {
			ChartDataEntry(x: $0.date!.timeIntervalSinceNow, y: $0.networth.doubleValue)
		}
	}

	public var balance: String {
		chartDataVM.last?.networth.chartPriceFormat ?? GlobalZeroAmounts.dollars.zeroAmount
	}

	public var volatilityPercentage: String {
		formattedVolatility(valueChangePercentage())
	}

	public var volatilityType: AssetVolatilityType {
		volatilityType(valueChangePercentage())
	}

	public var chartDate: String {
		let chartDateBuilder = ChartDateBuilder(dateFilter: dateFilter)
		return chartDateBuilder.timeFrame()
	}

	init(chartDataVM: [AssetChartDataViewModel], dateFilter: ChartDateFilter) {
		self.chartDataVM = chartDataVM
		self.dateFilter = dateFilter
	}

	// MARK: - Private Methods

	private func valueChangePercentage() -> BigNumber {
		if chartDataVM.count > 1 {
			let valueChangePercentage = valueChangePercentage(
				pointValue: chartDataVM[chartDataVM.count - 1].networth,
				previousValue: chartDataVM[0].networth
			)
			return valueChangePercentage
		} else {
			return 0.bigNumber
		}
	}

	// MARK: - Public Methods

	public func valueChangePercentage(pointValue: Double, previousValue: Double?) -> BigNumber {
		if let previousValue, previousValue != 0 {
			let pointValueNumber = BigNumber(numberWithDecimal: pointValue.description)!
			let previousValueNumber = BigNumber(numberWithDecimal: previousValue.description)!
			let changePercentage = ((pointValueNumber - previousValueNumber) / previousValueNumber)! * 100.bigNumber
			return changePercentage
		} else {
			return 0.bigNumber
		}
	}

	public func valueChangePercentage(pointValue: BigNumber, previousValue: BigNumber?) -> BigNumber {
		if let previousValue, !previousValue.isZero {
			let changePercentage = ((pointValue - previousValue) / previousValue)! * 100.bigNumber
			return changePercentage
		} else {
			return 0.bigNumber
		}
	}

	public func formattedVolatility(_ valueChangePercentage: BigNumber) -> String {
		if valueChangePercentage.isZero {
			return GlobalZeroAmounts.percentage.zeroAmount
		}
		let volatilityType = volatilityType(valueChangePercentage)
		switch volatilityType {
		case .profit:
			return "\(volatilityType.prependSign)\(valueChangePercentage.percentFormat)%"
		case .loss, .none:
			return "\(valueChangePercentage.percentFormat)%"
		}
	}

	public func volatilityType(_ valueChangePercentage: BigNumber) -> AssetVolatilityType {
		if valueChangePercentage > 0.bigNumber {
			return .profit
		} else if valueChangePercentage < 0.bigNumber {
			return .loss
		} else {
			return .none
		}
	}

	public func selectedDate(timeStamp: Double) -> String {
		let date = Date(timeIntervalSinceNow: timeStamp)
		let chartDateBuilder = ChartDateBuilder(dateFilter: dateFilter)
		return chartDateBuilder.selectedDate(date: date)
	}
}
