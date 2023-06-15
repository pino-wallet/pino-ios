//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import Foundation
import Web3
import Web3ContractABI

// Optional
import Web3PromiseKit

enum Web3Error: Error {
	case invalidSmartContractAddress
}

class Web3Core {
	// MARK: - Private Properties

	private let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
	private init() {}

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

	// MARK: - Private Methods

	private func getInfo(address: String, info: AssetInfo) throws -> Promise<[String: Any]> {
		let contractAddress = try! EthereumAddress(hex: address, eip55: true)
		let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
		let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)

		return try contract[info.rawValue]!(EthereumAddress(hex: address, eip55: true)).call()
	}
}
