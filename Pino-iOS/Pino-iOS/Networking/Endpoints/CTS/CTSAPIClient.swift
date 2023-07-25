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

	public var defaultTokenID = "0x0000000000000000000000000000000000000000"

	// MARK: - Public Methods

	public func tokens() -> AnyPublisher<[Detail], APIError> {
		networkManager.request(.tokens)
	}
}
