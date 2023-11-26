//
//  AccountActivationModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/4/23.
//

import BigInt
import Combine
import Foundation
import Web3

// MARK: - AccountActivationModel

struct AccountActivationRequestModel: Codable {
	let address, sig: String
	let time: BigUInt

	public var reqBody: BodyParamsType {
		let params: HTTPParameters = [
			"Name": address,
			"sig": sig,
			"time": time,
		]
		return BodyParamsType.json(params)
	}

	public static func activationHashType(userAddress: String, createdTime: BigUInt) -> BodyParamsType {
		let typedData: [String: Any] = [
			"Types": [
				"ActivationRequest": [
					["Name": "address", "Type": "string"],
					["Name": "time", "Type": "string"],
				],
				"EIP712Domain": [
					["Name": "name", "Type": "string"],
					["Name": "version", "Type": "string"],
					["Name": "chainId", "Type": "uint256"],
					["Name": "verifyingContract", "Type": "address"],
				],
			],
			"PrimaryType": "ActivationRequest",
			"Domain": [
				"ChainId": "\(Web3Network.chainID)",
				"Name": "pino",
				"VerifyingContract": "0x0000000000000000000000000000000000000000",
				"Version": "1",
			],
			"Message": [
				"address": userAddress,
				"time": createdTime,
			],
		]
		return BodyParamsType.json(typedData)
	}
}

class AccountActivationViewModel {
	private var accountingAPIClient = AccountingAPIClient()
	private let web3APIClient = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()

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

struct AccountActivationModel: Codable {
	let id: String
}
