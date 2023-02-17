//
//  WalletAPIMockClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

final class WalletAPIMockClient: WalletAPIService {
	// MARK: Public Methods

	public func walletInfo() -> AnyPublisher<WalletInfoModel, APIError> {
		StubManager.publisher(for: "wallet-info-stub")
	}

	public func walletBalance() -> AnyPublisher<WalletBalanceModel, APIError> {
		StubManager.publisher(for: "wallet-balance-stub")
	}

	public func walletsList() -> AnyPublisher<WalletsStubModel, APIError> {
		StubManager.publisher(for: "wallets-stub")
	}
}
