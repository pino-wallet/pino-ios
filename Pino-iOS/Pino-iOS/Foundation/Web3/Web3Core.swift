//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import BigInt
import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

enum Web3Error: Error {
	case invalidSmartContractAddress
	case failedTransaction
	case insufficientBalance
}

public class Web3Core {
	// MARK: - Private Properties

	private init() {}
	private var web3: Web3 {
		if let testURL = AboutPinoView.web3URL {
			return Web3(rpcURL: testURL)
		} else {
			return Web3(rpcURL: Web3Core.RPC.mainNet.rawValue)
		}
	}

	private var trxManager: W3TransferManager {
		.init(web3: web3)
	}

	private var gasInfoManager: W3GasInfoManager {
		.init(web3: web3)
	}

	private var transferManager: W3TransferManager {
		.init(web3: web3)
	}

	private var approveManager: W3ApproveManager {
		.init(web3: web3)
	}

	private var swapManager: W3SwapManager {
		.init(web3: web3)
	}

	private let walletManager = PinoWalletManager()

	// MARK: - Typealias

	public typealias CustomAssetInfo = [ABIMethodCall: String]

	// MARK: - Public Properties

	public static var shared = Web3Core()

	// MARK: - Public Methods

	public func getChecksumOfEip55Address(eip55Address: String) -> String {
		do {
			let ethAddress = try EthereumAddress(hex: eip55Address, eip55: false)
			return ethAddress.hex(eip55: true)
		} catch {
			fatalError("Cannot get checksum of wrong eip55 address")
		}
	}

	public func getAllowanceOf(
		contractAddress: String,
		spenderAddress: String,
		ownerAddress: String
	) throws -> Promise<BigUInt> {
		try callABIMethod(
			method: .allowance,
			abi: .erc,
			contractAddress: contractAddress.eip55Address!,
			params: ownerAddress.eip55Address!,
			spenderAddress.eip55Address!
		)
	}

	public func approveContract(address: String, amount: BigUInt, spender: String) -> Promise<String> {
		approveManager.approveContract(address: address, amount: amount, spender: spender)
	}

	public func getApproveCallData(contractAdd: String, amount: BigUInt, spender: String) -> Promise<String> {
		approveManager.getApproveCallData(contractAdd: contractAdd, amount: amount, spender: spender)
	}

	public func getApproveProxyCallData(tokenAdd: String, spender: String) -> Promise<String> {
		approveManager.getApproveProxyCallData(tokenAdd: tokenAdd, spender: spender)
	}

	public func getPermitTransferCallData(
		amount: BigUInt,
		tokenAdd: String,
		signiture: String,
		nonce: BigUInt,
		deadline: BigUInt
	) -> Promise<String> {
		transferManager.getPermitTransferFromCallData(
			amount: amount,
			tokenAdd: tokenAdd,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	public func getWrapETHCallData(proxyFee: BigUInt) -> Promise<String> {
		swapManager.getWrapETHCallData(proxyFee: proxyFee)
	}

	public func getUnwrapETHCallData(recipient: String) -> Promise<String> {
		swapManager.getUnWrapETHCallData(recipient: recipient)
	}

	public func getParaswapSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swapParaswap)
	}

	public func getOneInchSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swap1Inch)
	}

	public func getZeroXSwapCallData(data: String) -> Promise<String> {
		swapManager.getSwapProviderData(callData: data, method: .swap0x)
	}

	public func getSweepTokenCallData(tokenAdd: String, recipientAdd: String) -> Promise<String> {
		swapManager.getSweepTokenCallData(tokenAdd: tokenAdd, recipientAdd: recipientAdd)
	}

	public func callProxyMulticall(data: [String], value: BigUInt) -> Promise<String> {
		swapManager.callMultiCall(
			callData: data,
			value: value
		)
	}

	public func getCustomAssetInfo(contractAddress: String) -> Promise<CustomAssetInfo> {
		var assetInfo: CustomAssetInfo = [:]

		return Promise<CustomAssetInfo>() { seal in
			let _ = firstly {
				try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
			}.then { conctractCode in
				if conctractCode.hex() == Constants.eoaCode {
					// In this case the smart contract belongs to an EOA
					throw Web3Error.invalidSmartContractAddress
				}
				return try self.getInfo(address: contractAddress, info: .decimal, abi: .erc)
			}.then { decimalValue in
				if String(describing: decimalValue[.emptyString]) == "0" {
					throw Web3Error.invalidSmartContractAddress
				}
				assetInfo[ABIMethodCall.decimal] = "\(decimalValue[String.emptyString]!)"
				return try self.getInfo(address: contractAddress, info: .name, abi: .erc).compactMap { nameValue in
					nameValue[String.emptyString] as? String
				}
			}.then { [self] nameValue -> Promise<[String: Any]> in
				assetInfo.updateValue(nameValue, forKey: ABIMethodCall.name)
				let contractAddress = try EthereumAddress(hex: contractAddress, eip55: true)
				let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
				return try contract
					.balanceOf(address: EthereumAddress(hex: walletManager.currentAccount.eip55Address, eip55: true))
					.call()
			}.map { balanceValue in
				balanceValue["_balance"] as! BigUInt
			}.then { balance in
				assetInfo.updateValue("\(balance)", forKey: ABIMethodCall.balance)
				return try self.getInfo(address: contractAddress, info: .symbol, abi: .erc).compactMap { symbolValue in
					symbolValue[String.emptyString] as? String
				}
			}.done { symbol in
				assetInfo.updateValue(symbol, forKey: ABIMethodCall.symbol)
				seal.fulfill(assetInfo)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func getETHBalance(of accountAddress: String) -> Promise<String> {
		Promise<String>() { seal in
			firstly {
				web3.eth.getBalance(address: accountAddress.eip55Address!, block: .latest)
			}.map { balanceValue in
				BigNumber(unSignedNumber: balanceValue.quantity, decimal: 18)
			}.done { balance in
				seal.fulfill(balance.sevenDigitFormat.ethFormatting)
			}.catch(policy: .allErrors) { error in
				seal.reject(error)
			}
		}
	}

	public func calculateEthGasFee() -> Promise<GasInfo> {
		gasInfoManager.calculateEthGasFee()
	}

	public func calculateSendERCGasFee(
		address: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<GasInfo> {
		gasInfoManager.calculateSendERCGasFee(
			recipient: address,
			amount: amount,
			tokenContractAddress: tokenContractAddress
		)
	}

	public func sendEtherTo(address: String, amount: BigUInt) -> Promise<String> {
		transferManager.sendEtherTo(recipient: address, amount: amount)
	}

	public func sendERC20TokenTo(
		recipient: String,
		amount: BigUInt,
		tokenContractAddress: String
	) -> Promise<String> {
		transferManager.sendERC20TokenTo(
			recipientAddress: recipient,
			amount: amount,
			tokenContractAddress: tokenContractAddress
		)
	}

	public func getTransactionByHash(txHash: String) -> Promise<EthereumTransactionObject?> {
		Promise<EthereumTransactionObject?>() { seal in
			firstly {
				guard let txHashBytes = Data.fromHex(txHash) else {
					fatalError("cant get bytes from txHash string")
				}
				return web3.eth.getTransactionByHash(blockHash: try EthereumData(txHashBytes))
			}.done { transactionObject in
				seal.fulfill(transactionObject)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func speedUpTransaction(tx: EthereumTransactionObject, newGasPrice: EthereumQuantity) -> Promise<String> {
		Promise<String>() { seal in
			let privateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
			firstly {
				var newTx = EthereumTransaction(nonce: tx.nonce, gasPrice: newGasPrice, to: tx.to, value: tx.value)
				newTx.gasLimit = tx.gas
				newTx.transactionType = .legacy

				return try newTx.sign(with: privateKey, chainId: 1).promise
			}.then { newTx in
				self.web3.eth.sendRawTransaction(transaction: newTx)
			}.done { txHash in
				seal.fulfill(txHash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getGasPrice() -> Promise<EthereumQuantity> {
		Promise<EthereumQuantity>() { seal in
			firstly {
				web3.eth.gasPrice()
			}.done { gasPrice in
				seal.fulfill(gasPrice)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	// MARK: - Private Methods

	private func getInfo(address: String, info: ABIMethodCall, abi: Web3ABI) throws -> Promise<[String: Any]> {
		let contractAddress = try EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = abi.abi
		let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract[info.rawValue]!(contractAddress).call()
	}

	private func callABIMethod<T, ABIParams: ABIEncodable>(
		method: ABIMethodCall,
		abi: Web3ABI,
		contractAddress: EthereumAddress,
		params: ABIParams...
	) throws -> Promise<T> {
		// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
		let contract = try web3.eth.Contract(json: abi.abi, abiKey: nil, address: contractAddress)
		// Get balance of some address

		return Promise<T>() { seal in
			firstly {
				contract[method.rawValue]!(params).call()
			}.map { response in
				response[.emptyString] as! T
			}.done { allowance in
				seal.fulfill(allowance)
			}.catch(policy: .allErrors) { error in
				print(error)
				seal.reject(error)
			}
		}
	}

	public static func getContractOfToken(
		address tokenContractAddress: String,
		abi: Web3ABI,
		web3: Web3
	) throws -> DynamicContract {
		let contractAddress = tokenContractAddress.eip55Address!
		let contractJsonABI = abi.abi
		// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
		let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
		return contract
	}
}

extension Web3Core {
	public enum Constants {
		static let ethGasLimit = "21000"
		static let eoaCode = "0x"
		static let permitAddress = "0x000000000022D473030F116dDEE9F6B43aC78BA3"
		static let pinoProxyAddress = "0x118E662de0C4cdc2f8AD0fb1c6Ef4a85222baCF0"
		static let paraSwapETHID = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
		static let oneInchETHID = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
		static let zeroXETHID = "ETH"
		static let pinoETHID = "0x0000000000000000000000000000000000000000"
	}

	public enum RPC: String {
		case mainNet = "https://rpc.ankr.com/eth"
		case arb = "https://arb1.arbitrum.io/rpc"
		case ganashDev = "https://ganache.pino.xyz/"
	}
}
