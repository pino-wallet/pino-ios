//
//  APIMockClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

#warning("UsersAPIMockClient is temporary and its for demonstration of network layer")
final class UsersAPIMockClient: UsersAPIService {
	func users() -> AnyPublisher<Users, APIError> {
		publisher(for: "all-users-stub")
	}

	func userDetail(id: String) -> AnyPublisher<UserModel, APIError> {
		publisher(for: "all-users-stub")
	}
}

extension UsersAPIMockClient {
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
