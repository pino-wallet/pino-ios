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
	func userPortfolio(timeFrame: String, tokensId: [String]) -> AnyPublisher<[ChartDataModel], APIError>
	func coinPerformance(timeFrame: String, tokenID: String) -> AnyPublisher<[ChartDataModel], APIError>
	func activateAccount(activationReqModel: AccountActivationRequestModel)
		-> AnyPublisher<AccountActivationModel, APIError>
	func activeAddresses(addresses: [String]) -> AnyPublisher<ActiveAddressesModel, APIError>
	func activateAccountWithInviteCode(inviteCode: String) -> AnyPublisher<ActivateAccountWithInviteCodeModel, APIError>
}
