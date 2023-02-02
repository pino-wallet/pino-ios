//
//  WalletAPIClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

final class WalletAPIClient: WalletAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<WalletEndpoint>(keychainService: KeychainSwift())

	// MARK: - Public Methods

	public func walletInfo() -> AnyPublisher<WalletInfoModel, APIError> {
		networkManager.request(.walletInfo)
	}

	public func walletBalance() -> AnyPublisher<WalletBalanceModel, APIError> {
		networkManager.request(.walletBalance)
	}
}
