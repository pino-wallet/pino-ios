//
//  APIService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

protocol AccountingAPIService {
    func userBalance() -> AnyPublisher<BalanceModel, APIError>
}
