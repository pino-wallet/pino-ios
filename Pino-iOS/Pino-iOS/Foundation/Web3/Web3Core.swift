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


class Web3Core {
    
    private let web3 = Web3(rpcURL: "https://rpc.ankr.com/eth")
    private let readNodeContractKey = "0"
    private let userAddressStaticCode = "0x"
    
    public func getCustomAssetInfo(contractAddress: String) -> AddCustomAssetViewModel.ContractValidationStatus {
    
        let validateIsSmartContractStatus = validateIsSmartContract(contractAddress: contractAddress)
        return .error(.alreadyAdded)
//        if validateIsSmartContractStatus == .success {
//            return await validateIsERC20Token(contractAddress: contractAddress)
//        } else {
//            return validateIsSmartContractStatus
//        }
    }

    private func validateIsSmartContract(contractAddress: String) {
        
        firstly {
            try web3.eth.getCode(address: .init(contractAddress), block: .latest)
        }.done { conctractCode in
            print(conctractCode)
        }
        
//        let nodeRequest =
//        var nodeResponse: APIResponse<String>!
//        do {
//            nodeResponse = try await APIRequest.sendRequest(with: web3.provider, for: nodeRequest)
//        } catch {
//            return .error(.unavailableNode)
//        }
//        if nodeResponse.result == userAddressStaticCode {
//            return .error(.notValidSmartContractAddress)
//        } else {
//            return .success
//        }
    }

//    private func validateIsERC20Token(contractAddress: String) async -> ContractValidationStatus {
//        let contract = web3.contract(erc20AbiString, at: EthereumAddress(from: contractAddress))
//
//        let readBalanceOfOpParameters = [userAddress]
//
//        let readTokenNameOp = contract?.createReadOperation("name")
//        let readTokenSymbolOp = contract?.createReadOperation("symbol")
//        let readTokenBalanceOfOp = contract?.createReadOperation("balanceOf", parameters: readBalanceOfOpParameters)
//        let readTokenDecimalsOp = contract?.createReadOperation("decimals")
//
//        do {
//            guard let tokenName = try await readTokenNameOp?.callContractMethod()[readNodeContractKey] as? String else {
//                return .error(.notValidFromServer)
//            }
//            guard let tokenSymbol = try await readTokenSymbolOp?.callContractMethod()[readNodeContractKey] as? String
//            else {
//                return .error(.notValidFromServer)
//            }
//            guard let tokenBalanceOf = try await readTokenBalanceOfOp?.callContractMethod()[readNodeContractKey] else {
//                return .error(.notValidFromServer)
//            }
//
//            guard let tokenDecimals = try await readTokenDecimalsOp?
//                .callContractMethod()[readNodeContractKey] as? BigUInt else {
//                return .error(.notValidFromServer)
//            }
//
//            customAssetVM = CustomAssetViewModel(customAsset: CustomAssetModel(
//                id: contractAddress,
//                name: tokenName,
//                symbol: tokenSymbol,
//                balance: tokenBalanceOf,
//                decimal: tokenDecimals
//            ))
//            return .success
//        } catch {
//            return .error(.unknownError)
//        }
//    }
}
