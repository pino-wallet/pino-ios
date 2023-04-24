//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class AccountingAPIClient: AccountingAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<AccountingEndpoint>(keychainService: KeychainSwift())

	// MARK: - Public Methods

	public func userBalance() -> AnyPublisher<BalanceModel, APIError> {
		networkManager.request(.balances)
	}

	public func userPortfolio(timeFrame: String) -> AnyPublisher<PortfolioModel, APIError> {
		networkManager.request(.portfolio(timeFrame: timeFrame))
	}
}

struct NoContent: Codable {}
