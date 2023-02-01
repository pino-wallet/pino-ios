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
		publisher(for: "wallet-info-stub")
	}

	public func walletBalance() -> AnyPublisher<WalletBalanceModel, APIError> {
		publisher(for: "wallet-balance-stub")
	}
}

extension WalletAPIMockClient {
	// MARK: Fileprivate Methods

	fileprivate func publisher<T: Decodable>(for resource: String) -> AnyPublisher<T, APIError> {
		Just(stubData(for: resource))
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}

	fileprivate func stubData<T: Decodable>(for resource: String) -> T {
		guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
		      let data = try? Data(contentsOf: url),
		      let mockData = try? JSONDecoder().decode(T.self, from: data)
		else {
			fatalError("Mock data not found")
		}
		return mockData
	}
}
