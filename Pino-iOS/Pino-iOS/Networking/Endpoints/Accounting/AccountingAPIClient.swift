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
		GlobalVariables.shared.currentAccount.eip55Address
	}
    
    private var currentDeviceID: String {
        UIDevice.current.identifierForVendor!.uuidString
    }

    // MARK: - Private Methods
    private func getDeviceID() -> String {
        let cloudKitManager = CloudKitKeyStoreManager(key: .inviteCode)
        if let deviceID = cloudKitManager.getValue() {
            return deviceID
        } else {
            return currentDeviceID
        }
    }
    
	// MARK: - Public Methods

	public func userBalance() -> AnyPublisher<BalanceModel, APIError> {
		networkManager.request(.balances(accountADD: currentAccountAdd))
	}

	public func userPortfolio(timeFrame: String, tokensId: [String]) -> AnyPublisher<[ChartDataModel], APIError> {
		networkManager.request(
			.portfolio(timeFrame: timeFrame, accountADD: currentAccountAdd, tokensId: tokensId)
		)
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

	func activateDeviceWithInviteCode(inviteCode: String)
		-> AnyPublisher<ActivateAccountWithInviteCodeModel, APIError> {
		networkManager.request(.activateAccountWithInviteCode(deciveID: currentDeviceID, inviteCode: inviteCode))
	}

	func validateDeviceForBeta() -> AnyPublisher<ValidateDeviceForBetaModel, APIError> {
		networkManager.request(.validateDeviceForBeta(deviceID: getDeviceID()))
	}

	func getAllTimePerformanceOf(_ tokenID: String) -> AnyPublisher<TokenAllTimePerformance, APIError> {
		networkManager.request(.tokenAllTime(accountADD: currentAccountAdd, tokenID: tokenID))
	}
}

struct NoContent: Codable {}
