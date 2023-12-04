//
//  W3AaveRepayManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/3/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveRepayManager: Web3HelperProtocol {
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

	public func getRepayERCCallData(
		contract: DynamicContract,
		tokenAddress: String,
		amount: BigUInt
	) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.repayV3.rawValue]?(
				tokenAddress.eip55Address!,
				amount,
				BigUInt(Web3Core.Constants.aaveBorrowVariableInterestRate),
				walletManager.currentAccount.eip55Address.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}
}
