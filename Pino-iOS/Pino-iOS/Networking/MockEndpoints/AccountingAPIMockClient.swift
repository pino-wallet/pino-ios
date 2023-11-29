//
//  APIMockClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class AccountingAPIMockClient: AccountingAPIService {
	// MARK: Public Methods

	public func userBalance() -> AnyPublisher<BalanceModel, APIError> {
		StubManager.publisher(for: "user-balance-stub")
	}

	func userPortfolio(timeFrame: String) -> AnyPublisher<[ChartDataModel], APIError> {
		Just([])
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}

	func coinPerformance(timeFrame: String, tokenID: String) -> AnyPublisher<[ChartDataModel], APIError> {
		Just([])
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}

	func activateAccount(activationReqModel: AccountActivationRequestModel)
		-> AnyPublisher<AccountActivationModel, APIError> {
		Just(AccountActivationModel(id: "0x71C7656EC7ab88b098defB751B7401B5f6d8976F"))
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}

	func activeAddresses(addresses: [String]) -> AnyPublisher<ActiveAddressesModel, APIError> {
		Just(ActiveAddressesModel(addresses: ["0x71C7656EC7ab88b098defB751B7401B5f6d8976F"]))
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}
}
