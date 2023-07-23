//
//  ActivityAPIClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation

final class ActivityAPIClient: ActivityAPIService {
    
	// MARK: - Private Properties

	private let networkManager = NetworkManager<ActivityEndpoint>()

	// MARK: - Public Methods

	public func tokenActivities(userAddress: String, tokenAddress: String) -> AnyPublisher<ActivitiesModel, APIError> {
		networkManager.request(.tokenActivities(userAddress: userAddress, tokenAddress: tokenAddress))
	}

	public func allActivities(userAddress: String) -> AnyPublisher<ActivitiesModel, APIError> {
		networkManager.request(.allActivities(userAddress: userAddress))
	}
    
    public func singleActivity(txHash: String) -> AnyPublisher<ActivityModel, APIError> {
        networkManager.request(.singleActivity(txHash: txHash))
    }
}
