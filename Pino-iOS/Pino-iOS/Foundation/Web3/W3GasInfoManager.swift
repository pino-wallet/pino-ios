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

public struct W3GasInfoManager {
	// MARK: - Initilizer

	public init(web3: Web3) {
		self.web3 = web3
	}

	// MARK: - Private Properties

	private let web3: Web3!
	private var transactionManager: W3TransactionManager {
		.init(web3: web3)
	}

	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var walletManager = PinoWalletManager()
	private let pinoProxyAdd = Web3Core.Constants.pinoProxyAddress

	// MARK: - Public Methods

	private func calculateGasOf(
		method: ABIMethodWrite,
		contract: SolidityInvocation,
		contractAddress: EthereumAddress
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)

			firstly {
				web3.eth.gasPrice()
			}.then { gasPrice in
				web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map { ($0, gasPrice) }
			}.then { nonce, gasPrice in
				try transactionManager.createTransactionFor(
					contract: contract,
					nonce: nonce,
					gasPrice: gasPrice,
					gasLimit: nil
				).promise.map { ($0, nonce, gasPrice) }
			}.then { transaction, nonce, gasPrice in

				web3.eth.estimateGas(call: .init(
					from: transaction.from,
					to: contractAddress,
					gas: gasPrice,
					gasPrice: nil,
					value: nil,
					data: transaction.data
				)).map { ($0, nonce, gasPrice) }

			}.done { gasLimit, nonce, gasPrice in
				let gasInfo = GasInfo(gasPrice: gasPrice.quantity, gasLimit: gasLimit.quantity)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateEthGasFee() -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			attempt(maximumRetryCount: 3) { [self] in
				web3.eth.gasPrice()
			}.done { gasPrice in
				let gasLimit = try BigUInt(Web3Core.Constants.ethGasLimit)
				let gasInfo = GasInfo(gasPrice: gasPrice.quantity, gasLimit: gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateSendERCGasFee(
		recipient address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let to: EthereumAddress = try! EthereumAddress(hex: address, eip55: false)
				let checksumTo = try! EthereumAddress(hex: to.hex(eip55: true), eip55: true)
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
				let solInvocation = contract[ABIMethodWrite.transfer.rawValue]!(checksumTo, amount)
				return gasInfoManager.calculateGasOf(method: .transfer, contract: solInvocation, contractAddress: checksumTo)
			}.done { trxGasInfo in
				let gasInfo = GasInfo(gasPrice: trxGasInfo.gasPrice, gasLimit: trxGasInfo.gasLimit)
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateApproveFee(
		spender: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: tokenContractAddress, web3: web3)
				let solInvocation = contract[ABIMethodWrite.approve.rawValue]!(spender, amount)
				return gasInfoManager.calculateGasOf(
					method: .approve,
					contract: solInvocation,
					contractAddress: tokenContractAddress.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculatePermitTransferFromFee(
		spender: String,
		amount: BigUInt
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let nonce: BigUInt = 34_567_890
				let deadline: BigUInt = 34_567_890
				let contract = try Web3Core.getContractOfToken(address: pinoProxyAdd, web3: web3)
				let solInvocation = contract[ABIMethodWrite.permitTransferFrom.rawValue]!(
					nonce,
					spender.eip55Address,
					deadline,
					amount
				)
				return gasInfoManager.calculateGasOf(
					method: .permitTransferFrom,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateTokenSweepFee(
		tokenAdd: String,
		recipientAdd: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: pinoProxyAdd, web3: web3)
				let solInvocation = contract[ABIMethodWrite.sweepToken.rawValue]!(
					tokenAdd.eip55Address,
					recipientAdd.eip55Address
				)
				return gasInfoManager.calculateGasOf(
					method: .sweepToken,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateWrapETHFee(
		amount: BigUInt,
		proxyFee: BigUInt
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: pinoProxyAdd, web3: web3)
				let solInvocation = contract[ABIMethodWrite.wrapETH.rawValue]!(amount, proxyFee)
				return gasInfoManager.calculateGasOf(
					method: .wrapETH,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateUnWrapETHFee(
		amount: BigUInt,
		recipient: String
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: pinoProxyAdd, web3: web3)
				let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]!(amount, recipient.eip55Address)
				return gasInfoManager.calculateGasOf(
					method: .unwrapWETH9,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateMultiCallFee(
		callData: [String]
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let contract = try Web3Core.getContractOfToken(address: pinoProxyAdd, web3: web3)
				let solInvocation = contract[ABIMethodWrite.multicall.rawValue]!(callData)
				return gasInfoManager.calculateGasOf(
					method: .multicall,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func calculateTestTupleFee() -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			firstly {
				let test = TupleData(
					a: 1,
					b: 2,
					c: 3,
					d: 4,
					e: false,
					f: .init(
						permitted: .init(token: "0x8C00ad160683dF72ef165592e019E02f8d9e3AcD".eip55Address, amount: 6),
						nonce: 7,
						deadline: 8
					)
				)
				let contract = try Web3Core.getContractOfToken(
					address: "0x8C00ad160683dF72ef165592e019E02f8d9e3AcD",
					web3: web3
				)
				let solInvocation = contract["testTuple1"]!(test)
				return gasInfoManager.calculateGasOf(
					method: .testTuple1,
					contract: solInvocation,
					contractAddress: pinoProxyAdd.eip55Address
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}

struct TupleData: ABIEncodable {
	let a: Int8
	let b: Int8
	let c: Int8
	let d: Int8
	let e: Bool

	struct TokenPermissions {
		let token: EthereumAddress
		let amount: Int
	}

	struct PermitTransferFrom {
		let permitted: TokenPermissions
		let nonce: Int
		let deadline: Int
	}

	let f: PermitTransferFrom

	func abiEncode(dynamic: Bool) -> String? {
		// Encode the primitive types
		let aEncoded = String(a, radix: 16).paddingLeft(toLength: 64, withPad: "0")
		let bEncoded = String(b, radix: 16).paddingLeft(toLength: 64, withPad: "0")
		let cEncoded = String(c, radix: 16).paddingLeft(toLength: 64, withPad: "0")
		let dEncoded = String(d, radix: 16).paddingLeft(toLength: 64, withPad: "0")
		let eEncoded = e.abiEncode(dynamic: false)

		// Encoding TokenPermissions
		let tokenEncoded = f.permitted.token.abiEncode(dynamic: false)
		let amountEncoded = String(f.permitted.amount, radix: 16).paddingLeft(toLength: 64, withPad: "0")

		// Encoding PermitTransferFrom
		let nonceEncoded = String(f.nonce, radix: 16).paddingLeft(toLength: 64, withPad: "0")
		let deadlineEncoded = String(f.deadline, radix: 16).paddingLeft(toLength: 64, withPad: "0")

		// Concatenate all the encoded strings
		let permitString = tokenEncoded! + amountEncoded + nonceEncoded + deadlineEncoded
		var encodedString = aEncoded + bEncoded + cEncoded + dEncoded + eEncoded!

		return "\(encodedString)\(permitString)"
	}
}

// Dummy implementation for 'paddingLeft' since it's not provided
extension String {
	func paddingLeft(toLength: Int, withPad: String) -> String {
		let paddingCount = toLength - count
		guard paddingCount > 0 else { return self }

		let padding = String(repeating: withPad, count: paddingCount)
		return padding + self
	}
}
