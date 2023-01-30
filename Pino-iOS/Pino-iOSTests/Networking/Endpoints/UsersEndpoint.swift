//
//  UsersEndpoint.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/30/23.
//

import Foundation

internal enum UsersEndpoint: EndpointType {
    
    // MARK: - Cases

    case users

    // MARK: - Fileprivate Properties

    internal var path: String {
        switch self {
        case .users:
            return "/api/users"
        }
    }

    internal var stubPath: String {
        switch self {
        case .users:
            return "all-users-stub.json"
        }
    }
}
