//
//  WalletAPIService.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

protocol WalletAPIService {
	func walletInfo() -> AnyPublisher<WalletInfoModel, APIError>
	func walletBalance() -> AnyPublisher<WalletBalanceModel, APIError>
}
