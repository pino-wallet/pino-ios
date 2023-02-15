//
//  StubManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 2/2/23.
//

import Combine
import Foundation

struct StubManager {
	// MARK: - Public Methods

	static func publisher<T: Decodable>(for resource: String) -> AnyPublisher<T, APIError> {
		Just(stubData(for: resource))
			.setFailureType(to: APIError.self)
			.eraseToAnyPublisher()
	}

	// MARK: - Private Methods

	static func stubData<T: Decodable>(for resource: String) -> T {
		guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
		      let data = try? Data(contentsOf: url),
		      let mockData = try? JSONDecoder().decode(T.self, from: data)
		else {
			fatalError("Mock data not found")
		}
		return mockData
	}
}
