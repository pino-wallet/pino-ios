//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

#warning("UsersEndpoint is temprary and only for network layer demonstration")
enum UsersEndpoint: EndpointType {
    // MARK: - Cases
    
    case users
    case userDetail(id: String)
    case register(user: UserModel)
    
    // MARK: - Internal Methods
        
    internal func request(privateKey: String?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if requiresAuthentication {
            if let privateKey {
                print(privateKey)
                // Add privateKey as a token
            } else {
                throw APIError.unauthorized
            }
        }
        
        try task.configParams(&request)
        
        return request
    }
    
    // MARK: - Internal Properties
    
    internal var requiresAuthentication: Bool {
        switch self {
        case .users, .userDetail, .register:
            return false
        }
    }
    
    internal var task: HTTPTask {
        switch self {
        case let .register(userInfo):
            return .requestParameters(
                bodyParameters: .object(userInfo),
                bodyEncoding: .jsonEncoding,
                urlParameters: nil
            )
        case .users, .userDetail:
            return .request
        }
    }
    
    internal var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "X-API-TOKEN": "token",
        ]
    }
    
    internal var url: URL {
        Environment.apiBaseURL.appendingPathComponent(path)
    }
    
    internal var path: String {
        switch self {
        case .users, .register:
            return "users"
        case let .userDetail(id):
            return "users/\(id)"
        }
    }
    
    internal var httpMethod: HTTPMethod {
        switch self {
        case .users, .userDetail:
            return .get
        case .register:
            return .post
        }
    }
   
}
