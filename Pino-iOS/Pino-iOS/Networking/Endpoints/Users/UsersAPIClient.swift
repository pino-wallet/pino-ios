//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class UsersAPIClient: UsersAPIService {
    
	// MARK: - Private Properties
    private let networkManager = NetworkManager<UsersEndpoint>(keychainService: KeychainSwift())
    
    // MARK: - Public Methods

    public func users() -> AnyPublisher<Users, APIError> {
        networkManager.request(.users)
    }
    
    public func userDetail(id: String) -> AnyPublisher<UserModel, APIError> {
        networkManager.request(.userDetail(id: id))
    }
}

struct NoContent: Codable {}

