//
//  AssetChartDataViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/18/23.
//

import Foundation

struct AssetChartDataViewModel {
	// MARK: - Public Properties

	public var chartModel: ChartDataModel

	public var date: Date? {
		getDate(from: chartModel.time)
	}

	public var networth: BigNumber {
		BigNumber(number: chartModel.networth, decimal: 2)
	}

	// MARK: - Private Methods

	private func getDate(from time: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: time)
		return date
	}
}
