//
//  Web3Core.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 6/11/23.
//

import Web3

// Optional
import Web3PromiseKit
import Web3ContractABI

enum Web3Error: Error {
    case invalidSmartContractAddress
}

class Web3Core {
    
    // MARK: - Private Properties
    
    private let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
    
    // MARK: - Public Properties

    public enum AssetInfo: String {
        case decimal = "decimals"
        case balance = "balanceOf"
        case name = "name"
        case symbol = "symbol"
    }
    
    // MARK: - Public Methods
        
    public func getCustomAssetInfo(contractAddress: String) throws -> Promise<[AssetInfo: String]> {
     
        var assetInfo: [AssetInfo: String] = [:]
        
        return Promise { seal in
            let _ = firstly {
                try web3.eth.getCode(address: .init(hex: contractAddress, eip55: true), block: .latest)
            }.then { conctractCode in
                if conctractCode.hex() == "0x" {
                    // In this case the smart contract belongs to an EOA
                    throw AddCustomAssetViewModel.CustomAssetValidationError.notValidSmartContractAddress
                } else {
                    return try self.getInfo(address: contractAddress, info: .decimal)
                }
            }.then { decimalValue in
                if String(describing: decimalValue[.emptyString]) == "0" {
                    throw AddCustomAssetViewModel.CustomAssetValidationError.notValidSmartContractAddress
                } else {
                    assetInfo[.decimal] = String(describing: decimalValue[.emptyString])
                    return try self.getInfo(address: contractAddress, info: .name)
                }
            }.then { name in
                assetInfo[.name] = String(describing: name[.emptyString])
                return try self.getInfo(address: contractAddress, info: .balance)
            }.then { balance in
                assetInfo[.balance] = String(describing: balance[.emptyString])
                return try self.getInfo(address: contractAddress, info: .symbol)
            }.done { symbol in
                assetInfo[.symbol] = String(describing: symbol[.emptyString])
                seal.resolve(assetInfo, nil)
            }
        }
        
    }
    
    // MARK: - Private Methods
    
    private func getInfo(address: String, info: AssetInfo) throws -> Promise<[String : Any]> {

        let contractAddress = try! EthereumAddress(hex: address, eip55: true)
        let contractJsonABI = Web3ABI.erc20AbiString.data(using: .utf8)!
        let contract = try! web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)

        return try contract[info.rawValue]!(EthereumAddress(hex: address, eip55: true)).call()
    }
    
}

