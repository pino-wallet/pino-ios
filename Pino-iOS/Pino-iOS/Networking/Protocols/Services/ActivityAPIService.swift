//
//  ActivityAPIService.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation

protocol ActivityAPIService {
	func tokenActivities(userAddress: String, tokenAddress: String) -> AnyPublisher<ActivitiesModel, APIError>
	func allActivities(userAddress: String) -> AnyPublisher<ActivitiesModel, APIError>
	func singleActivity(txHash: String) -> AnyPublisher<ActivityModel, APIError>
}
