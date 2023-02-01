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
		publisher(for: "assets-stub")
	}

	public func positions() -> AnyPublisher<Positions, APIError> {
		publisher(for: "positions-stub")
	}
}

extension AssetsAPIMockClient {
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
