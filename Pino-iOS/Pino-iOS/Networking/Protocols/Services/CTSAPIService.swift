//
//  CTSAPIService.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/27/23.
//

import Combine
import Foundation

protocol CTSAPIService {
	func tokens() -> AnyPublisher<[Detail], APIError>
}
