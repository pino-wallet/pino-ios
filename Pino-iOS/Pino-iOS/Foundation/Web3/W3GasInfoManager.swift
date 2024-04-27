//
//  W3GasInfoManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3GasInfoManager: Web3HelperProtocol {
	var writeWeb3: Web3
	var readWeb3: Web3

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func calculateGasOf(
		method: ABIMethodWrite,
		solInvoc: SolidityInvocation
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in

			firstly {
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
			}.then { nonce in
				let gasInfo = GasInfo()
				return try trxManager.createTransactionFor(
					contract: solInvoc,
					nonce: nonce,
					gasInfo: gasInfo
				).promise.map { ($0, nonce) }
			}.then { trx, nonce in
				readWeb3.eth.estimateGas(call: .init(
					from: trx.from,
					to: trx.to!,
					data: trx.data
				)).map { ($0, nonce) }
			}.done { gasLimit, nonce in
				let gasInfo = GasInfo(gasLimit: gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateGasOf(
		data: EthereumData,
		to: EthereumAddress,
		value: EthereumQuantity? = nil
	) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in

			firstly {
				readWeb3.eth
					.estimateGas(call: .init(
						from: userPrivateKey.address,
						to: to,
						value: value,
						data: data
					)).map { $0 }
			}.done { gasLimit in
				let gasInfo = GasInfo(gasLimit: gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateEthGasFee() -> GasInfo {
		let gasLimit = BigNumber(number: Web3Core.Constants.ethGasLimit, decimal: 0)
		let gasInfo = GasInfo(gasLimit: gasLimit.etherumQuantity)
		return gasInfo
	}

	public func calculateEthGasFee(enteredAmount: EthereumQuantity, to address: EthereumAddress) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			firstly {
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
			}.then { nonce in
				trxManager.createEthSendTrx(nonce: nonce, enteredAmount: enteredAmount, recepient: address).promise
					.map { ($0, nonce) }
			}.then { trx, nonce in
				readWeb3.eth
					.estimateGas(call: .init(
						from: userPrivateKey.address,
						to: address,
						value: enteredAmount
					)).map { $0 }
			}.done { gasLimit in
				let gasInfo = GasInfo(gasLimit: gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateSendERCGasFee(
		recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, abi: .erc, web3: readWeb3)
				let solInvocation = contract[ABIMethodWrite.transfer.rawValue]!(recipient.eip55Address!, amount)
				return gasInfoManager.calculateGasOf(
					method: .transfer,
					solInvoc: solInvocation
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
