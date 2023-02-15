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
	// MARK: Public Methods

	public func users() -> AnyPublisher<Users, APIError> {
		StubManager.publisher(for: "all-users-stub")
	}

	public func userDetail(id: String) -> AnyPublisher<UserModel, APIError> {
		StubManager.publisher(for: "all-users-stub")
	}
}
