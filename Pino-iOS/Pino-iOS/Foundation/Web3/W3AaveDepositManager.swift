//
//  W3AaveDepositManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/22/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveDepositManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var walletManager = PinoWalletManager()
	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var trxManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var userPrivateKey: EthereumPrivateKey {
		try! EthereumPrivateKey(
			hexPrivateKey: walletManager.currentAccountPrivateKey
				.string
		)
	}

	// MARK: - Public Methods

	public func getAaveDespositV3ERCCallData(
		assetAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		Promise<String> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoProxyAddress,
				abi: .aaveProxy,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.depositV3.rawValue]?(
				assetAddress.eip55Address!,
				amount,
				userAddress.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}
}
