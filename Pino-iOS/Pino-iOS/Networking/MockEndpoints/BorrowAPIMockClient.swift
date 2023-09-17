//
//  BorrowAPIMockClient.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Combine
import Foundation

class BorrowAPIMockClient: BorrowAPIService {
	func getUserBorrowings(address: String, dex: String) -> AnyPublisher<UserBorrowingModel, APIError> {
		StubManager.publisher(for: "user-borrowing-stub")
	}
    
    func getBorrowableTokens(dex: String) -> AnyPublisher<BorrowableTokensModel, APIError> {
        StubManager.publisher(for: "borrowable-tokens-stub")
    }
}
