//
//  AccountActivationViewModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/26/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit

class AccountActivationViewModel {
	// MARK: - Public Properties

	private var accountingAPIClient = AccountingAPIClient()
	private let web3APIClient = Web3APIClient()
	private var cancellables = Set<AnyCancellable>()
	let activateTime = Date().timeIntervalSince1970

	// MARK: - Public Methods

	public func activateNewAccountAddress(_ account: Account) -> Promise<String> {
		firstly {
			fetchHash(address: account.eip55Address.lowercased(), activateTime: Int(activateTime))
		}.then { plainHash in
			self.signHash(plainHash: plainHash, userKey: account.privateKey.hexString)
		}.then { signiture in
			self.activateAccountWithHash(
				address: account.eip55Address.lowercased(),
				userHash: signiture,
				activateTime: Int(self.activateTime)
			)
		}
	}

	// MARK: - Private Methods

	private func activateAccountWithHash(address: String, userHash: String, activateTime: Int) -> Promise<String> {
		Promise<String> { seal in
			let accountInfo = AccountActivationRequestModel(
				address: address,
				sig: userHash,
				time: activateTime
			)
			accountingAPIClient.activateAccount(activationReqModel: accountInfo)
				.sink { completed in
					switch completed {
					case .finished:
						print("Wallet activated")
					case let .failure(error):
						seal.reject(error)
					}
				} receiveValue: { activatedAccount in
					seal.fulfill(activatedAccount.id)
				}.store(in: &cancellables)
		}
	}

	private func fetchHash(address: String, activateTime: Int) -> Promise<String> {
		Promise<String> { seal in
			let userActivationReq = AccountActivationRequestModel.activationHashType(
				userAddress: address,
				createdTime: activateTime
			)
			web3APIClient.getHashTypedData(eip712HashReqInfo: userActivationReq).sink { completed in
				switch completed {
				case .finished:
					print("User hash received successfully")
				case let .failure(error):
					seal.reject(error)
				}
			} receiveValue: { userHash in
				seal.fulfill(userHash.hash)
			}.store(in: &cancellables)
		}
	}

	func signHash(plainHash: String, userKey: String) -> Promise<String> {
		Promise<String> { seal in
			var signiture = try Sec256k1Encryptor.sign(
				msg: plainHash.hexToBytes(),
				seckey: userKey.hexToBytes()
			)
			signiture[signiture.count - 1] += 27

			seal.fulfill("0x\(signiture.toHexString())")
		}
	}
}
