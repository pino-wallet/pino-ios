//
//  AssetChartDataViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/18/23.
//

import Foundation

struct AssetChartDataViewModel {
	// MARK: - Private Properties

	private var chartModel: ChartDataModel
	private let networthDecimal: Int

	// MARK: - Public Properties

	public var date: Date? {
		getDate(from: chartModel.time)
	}

	public var networth: BigNumber {
		BigNumber(number: chartModel.networth, decimal: networthDecimal)
	}

	// MARK: - Initializers

	init(chartModel: ChartDataModel, networthDecimal: Int = 2) {
		self.chartModel = chartModel
		self.networthDecimal = networthDecimal
	}

	// MARK: - Private Methods

	private func getDate(from time: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.locale = Locale(identifier: Date().timeZoneIdentifier)
		dateFormatter.timeZone = TimeZone(secondsFromGMT: Date().timeZoneSecondsFromGMT)
		let date = dateFormatter.date(from: time)
		return date
	}
}
