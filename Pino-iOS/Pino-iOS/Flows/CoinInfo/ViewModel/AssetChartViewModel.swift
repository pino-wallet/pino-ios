//
//  AssetChartViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//
import Charts
import Foundation

struct AssetChartViewModel {
	// MARK: - Public Properties

	public let chartDataVM: [AssetChartDataViewModel]
	public var dateFilter: ChartDateFilter

	public var chartDataEntry: [ChartDataEntry] {
		chartDataVM.map { ChartDataEntry(x: $0.date.timeIntervalSinceNow, y: $0.networth.doubleValue) }
	}

	public var dateFilters: [ChartDateFilter] {
		[.hour, .day, .week, .month, .year, .all]
	}

	public var balance: String {
		"$\(chartDataVM.last!.networth.decimalString)"
	}

	public var volatilityPercentage: String {
		formattedVolatility(valueChangePercentage())
	}

	public var volatilityType: AssetVolatilityType {
		volatilityType(valueChangePercentage())
	}

	public var chartDate: String {
		let firstDate = chartDataVM.first!.date
		let lastDate = chartDataVM.last!.date
		switch dateFilter {
		case .hour, .day:
			return "\(firstDate.monthName()) \(firstDate.get(.day)), " +
				"\(firstDate.get(.year))"
		case .week:
			return "\(firstDate.monthName()) \(firstDate.get(.day)) - " +
				"\(lastDate.monthName()) \(lastDate.get(.day)), " +
				"\(lastDate.get(.year))"
		case .month:
			if firstDate.get(.year) == lastDate.get(.year) {
				return "\(firstDate.monthName()) \(firstDate.get(.day)) - " +
					"\(lastDate.monthName()) \(lastDate.get(.day)), " +
					"\(lastDate.get(.year))"
			} else {
				return "\(firstDate.monthName()) \(firstDate.get(.day)), " +
					"\(firstDate.get(.year)) - " +
					"\(lastDate.monthName()) \(lastDate.get(.day)), " +
					"\(lastDate.get(.year))"
			}

		case .year:
			return "\(firstDate.monthName()), \(firstDate.get(.year)) - " +
				"\(lastDate.monthName()), \(lastDate.get(.year))"
		case .all:
			return ""
		}
	}

	// MARK: - Private Methods

	private func valueChangePercentage() -> Double {
		if chartDataEntry.count > 1 {
			let valueChangePercentage = valueChangePercentage(
				pointValue: chartDataEntry[chartDataEntry.count - 1].y,
				previousValue: chartDataEntry[chartDataEntry.count - 2].y
			)
			return valueChangePercentage
		} else {
			return 0
		}
	}

	// MARK: - Public Methods

	public func valueChangePercentage(pointValue: Double, previousValue: Double?) -> Double {
		if let previousValue, previousValue != 0 {
			return ((pointValue - previousValue) / previousValue) * 100
		} else {
			return 0
		}
	}

	public func formattedVolatility(_ valueChangePercentage: Double) -> String {
		let formattedVolatolity = "\(String(format: "%.2f", valueChangePercentage))%"
		switch volatilityType(valueChangePercentage) {
		case .profit:
			return "+\(formattedVolatolity)"
		default:
			return formattedVolatolity
		}
	}

	public func volatilityType(_ valueChangePercentage: Double) -> AssetVolatilityType {
		if valueChangePercentage > 0 {
			return .profit
		} else if valueChangePercentage < 0 {
			return .loss
		} else {
			return .none
		}
	}
}
