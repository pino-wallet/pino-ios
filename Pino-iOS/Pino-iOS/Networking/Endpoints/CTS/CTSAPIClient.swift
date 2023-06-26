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
		"0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
		"0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9",
		"0x6b175474e89094c44da98b954eedeac495271d0f",
	]

	// MARK: - Public Methods

	public func tokens() -> AnyPublisher<[Detail], APIError> {
		networkManager.request(.tokens)
	}
}
