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
		chartModel.chartData.map {
			let timeStamp = getDate(from: $0.time)?.timeIntervalSinceNow
			return ChartDataEntry(x: timeStamp!, y: Double($0.networth))
		}
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
		let firstDate = getDate(from: chartModel.chartData.first!.time)!
		let lastDate = getDate(from: chartModel.chartData.last!.time)!
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

	private func getDate(from time: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: time)
		return date
	}
}
