//
//  BorrowAPIService.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Combine
import Foundation

protocol BorrowAPIService {
	func getUserBorrowings(address: String, dex: String) -> AnyPublisher<UserBorrowingModel, APIError>
	func getBorrowableTokens(dex: String) -> AnyPublisher<BorrowableTokensModel, APIError>
	func getBorrowableTokenDetails(dex: String, tokenID: String) -> AnyPublisher<BorrowableTokenDetailsModel, APIError>
	func getCollateralizableTokens(dex: String) -> AnyPublisher<CollateralizableTokensModel, APIError>
	func getPositionTokenId(underlyingTokenId: String, tokenProtocol: String, positionType: PositionTokenType)
		-> AnyPublisher<PositionTokenModel, APIError>
}

enum PositionTokenType: String {
	case investment
	case debt
}
