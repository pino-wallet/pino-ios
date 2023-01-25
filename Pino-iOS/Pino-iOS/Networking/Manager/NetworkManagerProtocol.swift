//
//  NetworkManagerProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/24/23.
//

import Foundation
import Combine

protocol NetworkRouter {
    associatedtype EndPoint: EndpointType
    func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError>
}
