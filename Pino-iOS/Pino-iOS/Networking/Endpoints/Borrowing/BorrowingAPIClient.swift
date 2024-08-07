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

	func getBorrowableTokens(dex: String) -> AnyPublisher<BorrowableTokensModel, APIError> {
		networkManager.request(.getBorrowableTokens(dex: dex))
	}

	func getBorrowableTokenDetails(dex: String, tokenID: String) -> AnyPublisher<BorrowableTokenDetailsModel, APIError> {
		networkManager.request(.getBorrowableTokenDetails(dex: dex, tokenID: tokenID))
	}

	func getCollateralizableTokens(dex: String) -> AnyPublisher<CollateralizableTokensModel, APIError> {
		networkManager.request(.getCollateralizableTokens(dex: dex))
	}

	func getPositionTokenId(
		underlyingTokenId: String,
		tokenProtocol: String,
		positionType: PositionTokenType
	) -> AnyPublisher<PositionTokenModel, APIError> {
		networkManager
			.request(.getPositionTokenId(
				underlyingTokenId: underlyingTokenId,
				tokenProtocol: tokenProtocol,
				positionType: positionType
			))
	}
}
