//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class UsersAPIClient: UsersAPIService {
    
	// MARK: - Properties
    let networkManager = NetworkManager<UsersEndpoint>(keychainService: KeychainSwift())
    
	// MARK: - Initialization

    func users() -> AnyPublisher<Users, APIError> {
        networkManager.request(.users)
    }
    
    func userDetail(id: String) -> AnyPublisher<UserModel, APIError> {
        networkManager.request(.userDetail(id: id))
    }
}

struct NoContent: Codable {}

