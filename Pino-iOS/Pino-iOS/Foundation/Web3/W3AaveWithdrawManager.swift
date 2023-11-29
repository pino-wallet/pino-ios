//
//  W3AaveWithdrawManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/25/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveWithdrawManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3
	internal let walletManager = PinoWalletManager()

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func getAaveWithdrawERCCallData(
		contract: DynamicContract,
		tokenAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.withdrawV3.rawValue]?(
				tokenAddress.eip55Address!,
				amount,
				userAddress.eip55Address!
			)
			let tx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(tx.data.hex())
		}
	}

	public func getAaveUnwrapWethCallData(contract: DynamicContract) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(
				walletManager.currentAccount.eip55Address
					.eip55Address!
			)
			let tx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(tx.data.hex())
		}
	}
}
