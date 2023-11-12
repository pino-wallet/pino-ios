//
//  W3TransferManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3SwapManager {
	// MARK: - Typealias

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

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

	// MARK: - Public Methods

	public func getSwapProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.pinoSwapProxyAddress,
			abi: .swap,
			web3: web3
		)
	}

	public func getSweepTokenCallData(tokenAdd: String, recipientAdd: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try getSwapProxyContract()
			let solInvocation = contract[ABIMethodWrite.sweepToken.rawValue]?(
				tokenAdd.eip55Address!,
				recipientAdd.eip55Address!
			)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getWrapETHCallData(contract: DynamicContract, proxyFee: BigUInt) -> Promise<String> {
		Promise<String>() { [self] seal in

			let solInvocation = contract[ABIMethodWrite.wrapETH.rawValue]?(proxyFee)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getUnWrapETHCallData(recipient: String) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try getSwapProxyContract()
			let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(recipient.eip55Address!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}

	public func getSwapProviderData(callData: String, method: ABIMethodWrite) -> Promise<String> {
		Promise<String>() { [self] seal in

			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.pinoSwapProxyAddress,
				abi: .swap,
				web3: web3
			)

			// Remove the "0x" prefix if present
			let cleanedHexString = callData.hasPrefix("0x") ? String(callData.dropFirst(2)) : callData

			// Calculate the length in characters
			let lengthInCharacters = cleanedHexString.count

			// Calculate the length in bytes
			let lengthInBytes = lengthInCharacters / 2

			let callD = Data(hexString: cleanedHexString, length: UInt(lengthInBytes))
			//            let callD2 = Data(callData.hexToBytes())
			//            let str = String.init(data: callD!, encoding: .utf8)!

			let solInvocation = contract[method.rawValue]?(callD!)

			let trx = try trxManager.createTransactionFor(
				contract: solInvocation!
			)

			seal.fulfill(trx.data.hex())
		}
	}
}
