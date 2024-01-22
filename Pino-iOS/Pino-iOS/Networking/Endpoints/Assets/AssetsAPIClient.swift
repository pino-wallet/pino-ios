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

	private let networkManager = NetworkManager<AssetsEndpoint>()

	// MARK: - Public Methods

	public func assets() -> AnyPublisher<Assets, APIError> {
		networkManager.request(.assets)
	}

	public func positions() -> AnyPublisher<Positions, APIError> {
		networkManager.request(.positions)
	}

	public func coinPortfolio() -> AnyPublisher<[CoinHistoryModel], APIError> {
		networkManager.request(.coinHistory)
	}

	func getAllPositionAssets() -> AnyPublisher<PositionAssetsModel, APIError> {
		networkManager.request(.getAllPositionAssets)
	}
}
