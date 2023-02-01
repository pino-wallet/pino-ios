//
//  AssetsAPIClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

final class AssetsAPIClient: AssetsAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<AssetsEndpoint>(keychainService: KeychainSwift())

	// MARK: - Public Methods

	public func assets() -> AnyPublisher<Assets, APIError> {
		networkManager.request(.assets)
	}
}
