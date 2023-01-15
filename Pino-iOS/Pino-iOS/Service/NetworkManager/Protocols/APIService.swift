//
//  APIService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

protocol TransactionsAPIService {
	func transactions() -> AnyPublisher<[Transaction], APIError>
    func transactionDetail(id: String) -> AnyPublisher<Transaction, APIError>
}

protocol WalletAPIService {
    func walletDetail(id: String) -> AnyPublisher<Transaction, APIError>
}
