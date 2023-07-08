//
//  ActivityEndPoint.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Foundation

enum ActivityEndpoint: EndpointType {
    // MARK: - Cases
    case tokenActivities(userAddress: String, tokenAddress: String)
    case allActivities(userAddress: String)
    
    // MARK: - Internal Methods
    internal func request() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        try task.configParams(&request)

        return request
    }
    
    // MARK: - Internal Properties
    
    var url: URL {
        return Environment.apiBaseURL.appendingPathComponent(path)
    }
    
    var path: String {
        switch self {
        case .tokenActivities(userAddress: let userAddress, tokenAddress: let tokenAddress):
            return "user/\(userAddress)/activities/\(tokenAddress)"
        case .allActivities(userAddress: let userAddress):
            return "user/\(userAddress)/activities"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .allActivities, .tokenActivities:
            return .request
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .allActivities, .tokenActivities:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
       return [
            "Content-Type": "application/json",
            "X-API-TOKEN": "token",
        ]
    }
    
}
