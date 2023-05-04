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
        #warning("just for test")
        return StubManager.publisher(for: "user-balance-stub")
    }
    
    func coinPerformance(timeFrame: String, tokenID: String) -> AnyPublisher<[ChartDataModel], APIError> {
        #warning("just for test")
        return StubManager.publisher(for: "user-balance-stub")
    }
    
    func activateAccountWith(address: String) -> AnyPublisher<AccountActivationModel, APIError> {
        return Just(AccountActivationModel(id: "0x71C7656EC7ab88b098defB751B7401B5f6d8976F"))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
