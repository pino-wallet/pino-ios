//
//  BorrowAPIService.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//
import Foundation
import Combine

protocol BorrowAPIService {
    func getUserBorrowings(address: String, dex: String) -> AnyPublisher<UserBorrowingModel, APIError>
}
