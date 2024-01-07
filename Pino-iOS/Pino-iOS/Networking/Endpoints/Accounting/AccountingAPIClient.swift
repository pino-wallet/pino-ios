//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation
import UIKit

final class AccountingAPIClient: AccountingAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<AccountingEndpoint>()
	private let pinoWalletManager = PinoWalletManager()
	private var currentAccountAdd: String {
		pinoWalletManager.currentAccount.eip55Address
	}

	private var deviceID: String {
		UIDevice.current.identifierForVendor!.uuidString
	}

	// MARK: - Public Methods

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

	func activateAccount(activationReqModel: AccountActivationRequestModel)
		-> AnyPublisher<AccountActivationModel, APIError> {
		networkManager.request(.activateAccount(activateReqModel: activationReqModel))
	}

	func activeAddresses(addresses: [String]) -> AnyPublisher<ActiveAddressesModel, APIError> {
		networkManager.request(.activeAddresses(addresses: addresses))
	}

	func activateAccountWithInviteCode(inviteCode: String)
		-> AnyPublisher<ActivateAccountWithInviteCodeModel, APIError> {
		networkManager.request(.activateAccountWithInviteCode(deciveID: deviceID, inviteCode: inviteCode))
	}
}

struct NoContent: Codable {}
