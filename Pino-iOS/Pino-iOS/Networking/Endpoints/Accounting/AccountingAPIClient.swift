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
	private let pinoWalletManager = PinoWalletManager()
	private var currentAccountAdd: String {
		pinoWalletManager.currentAccount.eip55Address
	}

	// MARK: - Public Methods

	public func cts() -> AnyPublisher<Detail, APIError> {
		networkManager.request(.cts)
	}

	public func userBalance() -> AnyPublisher<BalanceModel, APIError> {
		networkManager.request(.balances(accountADD: currentAccountAdd))
	}

	public func userPortfolio(timeFrame: String) -> AnyPublisher<[ChartDataModel], APIError> {
		networkManager.request(.portfolio(timeFrame: timeFrame, accountADD: currentAccountAdd))
	}

	public func coinPerformance(timeFrame: String, tokenID: String)
		-> AnyPublisher<[ChartDataModel], APIError> {
		networkManager.request(.coinPerformance(timeFrame: timeFrame, tokenID: tokenID, accountADD: currentAccountAdd))
	}

	func activateAccountWith(address: String) -> AnyPublisher<AccountActivationModel, APIError> {
		networkManager.request(.activateAccountWith(address: address))
	}
}

struct NoContent: Codable {}
