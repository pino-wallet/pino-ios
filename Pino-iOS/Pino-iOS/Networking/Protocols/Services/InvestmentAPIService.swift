//
//  InvestmentAPIService.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/12/23.
//

import Combine
import Foundation

protocol InvestmentAPIService {
	func investments() -> AnyPublisher<[InvestmentModel], APIError>
	func investPortfolio(timeFrame: String) -> AnyPublisher<[ChartDataModel], APIError>
	func investmentPerformance(timeFrame: String, investmentID: String) -> AnyPublisher<[ChartDataModel], APIError>
	func investmentDetail(address: String, investmentID: String) -> AnyPublisher<InvestAssetModel, APIError>
}
