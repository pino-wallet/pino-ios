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

	public let chartModel: AssetChartModel
	public var dateFilter: ChartDateFilter

	public var chartDataEntry: [ChartDataEntry] {
		chartModel.chartData.map { ChartDataEntry(x: Double($0.time)!, y: Double($0.networth)) }
	}

	public var dateFilters: [ChartDateFilter] {
		[.hour, .day, .week, .month, .year, .all]
	}

	public var balance: String {
		"$\(chartModel.balance)"
	}

	public var volatilityInDollor: String {
		switch volatilityType {
		case .profit:
			return "+$\(chartModel.volatilityInDollor)"
		case .loss:
			return "-$\(chartModel.volatilityInDollor)"
		case .none:
			return "$\(chartModel.volatilityInDollor)"
		}
	}

	public var volatilityPercentage: String {
		switch volatilityType {
		case .profit:
			return "+\(chartModel.volatilityPercentage)%"
		case .loss:
			return "-\(chartModel.volatilityPercentage)%"
		case .none:
			return "\(chartModel.volatilityPercentage)%"
		}
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(rawValue: chartModel.volatilityType) ?? .none
	}

	#warning("Chart date is temporary and must be calculated based on API data")
	public var chartDate: String {
		let date = Date()
		switch dateFilter {
		case .hour, .day:
			return "\(date.monthName()) \(date.get(.day)), \(date.get(.year))"
		case .week:
			let oneWeekAgo = date - 7
			return "\(oneWeekAgo.monthName()) \(oneWeekAgo.get(.day)) - \(date.monthName()) \(date.get(.day)), \(date.get(.year))"
		case .month:
			let oneMonthAgo = date - 30
			return "\(oneMonthAgo.monthName()) \(date.get(.day)) - \(date.monthName()) \(date.get(.day)), \(date.get(.year))"
		case .year:
			let oneYearAgo = date - 365
			return "\(date.monthName()), \(oneYearAgo.get(.year)) - \(date.monthName()), \(date.get(.year))"
		case .all:
			return ""
		}
	}
}
