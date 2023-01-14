//
//  APIService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

protocol APIService {
	func transactions() -> AnyPublisher<[Transaction], APIError>
}
