//
//  BuildBumberInfoService.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 3/26/24.
//

import Foundation
import Combine

protocol BuildBumberInfoService {
    func getCurrentAppBuildNumberInfo() -> AnyPublisher<BuildNumberInfo, APIError>
}
