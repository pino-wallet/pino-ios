//
//  Web3APIService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 9/6/23.
//

import Combine
import Foundation

protocol Web3APIService {
	func getHashTypedData(eip712HashReqInfo: EIP712HashRequestModel) -> AnyPublisher<EIP712HashResponseModel, APIError>
}
