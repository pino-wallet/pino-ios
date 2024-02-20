//
//  CTSAPIClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/27/23.
//

import Combine
import Foundation

final class CTSAPIClient: CTSAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<CTSEndpoint>()

	// MARK: - Public Properties

	public var defaultTokensID = [
		"0x0000000000000000000000000000000000000000",
		"0x6b175474e89094c44da98b954eedeac495271d0f",
		"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
	]

	// MARK: - Public Methods

	public func tokens() -> AnyPublisher<[Detail], APIError> {
		networkManager.request(.tokens)
	}
}
