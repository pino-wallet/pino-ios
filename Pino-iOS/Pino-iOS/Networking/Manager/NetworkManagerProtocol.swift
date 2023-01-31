//
//  NetworkManagerProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/24/23.
//

import Combine
import Foundation

protocol NetworkRouter {
	associatedtype EndPoint: EndpointType
	func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError>
}
