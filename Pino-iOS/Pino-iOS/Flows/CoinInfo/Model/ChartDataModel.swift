//
//  ChartDataModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//

struct ChartDataModel: Codable {
	// MARK: - public properties

	public var networth: Int
	public var time: String
}

typealias PortfolioModel = [ChartDataModel]
