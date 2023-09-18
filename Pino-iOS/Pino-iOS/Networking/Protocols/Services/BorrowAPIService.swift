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
    func getBorrowableToken(dex: String, tokenID: String) -> AnyPublisher<BorrowableTokenModel, APIError>
}
