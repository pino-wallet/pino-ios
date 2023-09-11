//
//  BorrowingAPIClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/11/23.
//

import Combine

final class BorrowingAPIClient: BorrowAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<BorrowingEndpoint>()

	// MARK: - Public Methods

	public func getUserBorrowings(address: String, dex: String) -> AnyPublisher<UserBorrowingModel, APIError> {
		networkManager.request(.getBorrowingDetails(address: address, dex: dex))
	}
}
