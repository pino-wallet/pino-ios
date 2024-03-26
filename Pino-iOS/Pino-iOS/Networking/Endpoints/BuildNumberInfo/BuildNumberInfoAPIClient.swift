//
//  BuildNumberInfoAPIClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 3/26/24.
//

import Foundation
import Combine

final class BuildNumberInfoAPIClient: BuildBumberInfoService {
    // MARK: - Private Properties
    private let networkManager = NetworkManager<BuildNumberInfoEndpoint>()
    
    // MARK: - Public Methods
    public func getCurrentAppBuildNumberInfo() -> AnyPublisher<BuildNumberInfo, APIError> {
        networkManager.request(.getCurrentAppBuildNumberInfo)
    }
}
