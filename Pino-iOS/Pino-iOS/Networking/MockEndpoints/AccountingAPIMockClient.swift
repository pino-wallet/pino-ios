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
}
