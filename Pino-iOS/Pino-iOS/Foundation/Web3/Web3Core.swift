//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import Foundation
import Web3
import Web3ContractABI
import Web3PromiseKit

enum Web3Error: Error {
	case invalidSmartContractAddress
}

class Web3Core {
	// MARK: - Private Properties

	private init() {}
	private let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
	private let walletManager = PinoWalletManager()

	typealias CustomAssetInfo = [AssetInfo: String]

	// MARK: - Public Properties

	public static var shared = Web3Core()
	public enum AssetInfo: String {
		case decimal = "decimals"
		case balance = "balanceOf"
		case name = "name"
		case symbol = "symbol"
	}

	// MARK: - Public Methods

	public func getCustomAssetInfo(contractAddress: String) throws -> Promise<CustomAssetInfo> {
		var assetInfo: CustomAssetInfo = [:]

		return Promise<CustomAssetInfo>() { seal in
			let _ = firstly {
				try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
			}.then { conctractCode in
				if conctractCode.hex() == "0x" {
					// In this case the smart contract belongs to an EOA
					seal.reject(Web3Error.invalidSmartContractAddress)
				}
				return try self.getInfo(address: contractAddress, info: .decimal)
			}.then { decimalValue in
				if String(describing: decimalValue[.emptyString]) == "0" {
					seal.reject(Web3Error.invalidSmartContractAddress)
				}
				assetInfo[AssetInfo.decimal] = "\(decimalValue[String.emptyString]!)"
				return try self.getInfo(address: contractAddress, info: .name).compactMap { nameValue in
					nameValue[String.emptyString] as? String
				}
			}.then { nameValue in
				assetInfo.updateValue(nameValue, forKey: AssetInfo.name)
				return try self.getInfo(address: contractAddress, info: .balance).compactMap { balanceValue in
					balanceValue[String.emptyString] as? BigUInt
				}
			}.then { balance in
				assetInfo.updateValue("\(balance)", forKey: AssetInfo.balance)
				return try self.getInfo(address: contractAddress, info: .symbol).compactMap { symbolValue in
					symbolValue[String.emptyString] as? String
				}
			}.done { symbol in
				assetInfo.updateValue(symbol, forKey: AssetInfo.symbol)
				seal.fulfill(assetInfo)
			}
		}
	}

	public func sendEtherTo(address: String, amount: BigUInt) throws -> Promise<String> {
		Promise<String>() { seal in
			let privateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
			firstly {
				web3.eth.gasPrice()
			}.then { [self] price in
				web3.eth.getTransactionCount(address: privateKey.address, block: .latest).map { ($0, price) }
			}.then { nonce, price in
				var tx = try EthereumTransaction(
					nonce: nonce,
					gasPrice: price,
					to: EthereumAddress(hex: address, eip55: true),
					value: EthereumQuantity(quantity: amount)
				)
				tx.gasLimit = 21000
				tx.transactionType = .legacy
				return try tx.sign(with: privateKey, chainId: 1).promise
			}.then { [self] tx in
				web3.eth.sendRawTransaction(transaction: tx)
			}.done { hash in
				seal.fulfill(hash.hex())
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	// MARK: - Private Methods

	private func getInfo(address: String, info: AssetInfo) throws -> Promise<[String: Any]> {
		let contractAddress = try! EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
		let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)

		return try contract[info.rawValue]!(EthereumAddress(hex: address, eip55: true)).call()
	}
}
