//
//  BorrowAPIMockClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Combine
import Foundation

class BorrowAPIMockClient: BorrowAPIService {
	func getPositionTokenId(
		underlyingTokenId: String,
		tokenProtocol: String,
		positionType: PositionTokenType
	) -> AnyPublisher<PositionTokenModel, APIError> {
		StubManager.publisher(for: "position-token-id-stub")
	}

	func getUserBorrowings(address: String, dex: String) -> AnyPublisher<UserBorrowingModel, APIError> {
		StubManager.publisher(for: "user-borrowing-stub")
	}

	func getBorrowableTokens(dex: String) -> AnyPublisher<BorrowableTokensModel, APIError> {
		StubManager.publisher(for: "borrowable-tokens-stub")
	}

	func getBorrowableTokenDetails(dex: String, tokenID: String) -> AnyPublisher<BorrowableTokenDetailsModel, APIError> {
		StubManager.publisher(for: "borrowable-token-stub")
	}

	func getCollateralizableTokens(dex: String) -> AnyPublisher<CollateralizableTokensModel, APIError> {
		StubManager.publisher(for: "collaterilizable-tokens-stub")
	}
}
