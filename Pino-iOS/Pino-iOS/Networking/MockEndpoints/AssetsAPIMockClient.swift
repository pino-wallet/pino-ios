//
//  AssetsAPIMockClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

final class AssetsAPIMockClient: AssetsAPIService {
	// MARK: Public Methods

	public func assets() -> AnyPublisher<Assets, APIError> {
        StubManager.publisher(for: "assets-stub")
	}

	public func positions() -> AnyPublisher<Positions, APIError> {
        StubManager.publisher(for: "positions-stub")
	}
}
