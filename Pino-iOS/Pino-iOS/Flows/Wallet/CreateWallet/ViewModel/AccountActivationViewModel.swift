//
//  AccountActivationViewModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/26/23.
//

import BigInt
import Combine
import Foundation

class AccountActivationViewModel {
	// MARK: - Public Properties

	private var accountingAPIClient = AccountingAPIClient()
	private let web3APIClient = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	#warning("Needs refactoring")
	public func activateNewAccountAddress(
		_ address: String,
		completion: @escaping (Result<String, WalletOperationError>) -> Void
	) {
		let accountImportedAt = BigUInt(Date().timeIntervalSince1970)
		let userActivationReq = AccountActivationRequestModel.activationHashType(
			userAddress: address,
			createdTime: accountImportedAt
		)
		web3APIClient.getHashTypedData(eip712HashReqInfo: userActivationReq).sink { completed in
			switch completed {
			case .finished:
				print("Wallet activated")
				completion(.success(""))
			case let .failure(error):
				completion(.failure(WalletOperationError.wallet(.accountActivationFailed(error))))
			}
		} receiveValue: { [self] userHash in
			let accountInfo = AccountActivationRequestModel(
				address: address,
				sig: userHash.hash,
				time: accountImportedAt
			)
			accountingAPIClient.activateAccount(activationReqModel: accountInfo)
				.retry(3)
				.sink(receiveCompletion: { completed in
					switch completed {
					case .finished:
						print("Wallet activated")
					case let .failure(error):
						completion(.failure(WalletOperationError.wallet(.accountActivationFailed(error))))
					}
				}) { activatedAccount in
					completion(.success(activatedAccount.id))
				}.store(in: &cancellables)
		}.store(in: &cancellables)
	}
}
