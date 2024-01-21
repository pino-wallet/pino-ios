//
//  AssetsAPIService.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

protocol AssetsAPIService {
	func assets() -> AnyPublisher<Assets, APIError>
	func positions() -> AnyPublisher<Positions, APIError>
    func getAllPositionAssets() -> AnyPublisher<PositionAssetsModel, APIError>
}
