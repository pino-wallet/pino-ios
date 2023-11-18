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

public struct W3GasInfoManager: Web3Manager {
    
    var writeWeb3: Web3
    var readWeb3: Web3
    
    init(writeWeb3: Web3, readWeb3: Web3) {
        self.readWeb3 = readWeb3
        self.writeWeb3 = writeWeb3
    }

	// MARK: - Public Methods

	public func calculateGasOf(
		method: ABIMethodWrite,
		solInvoc: SolidityInvocation,
		contractAddress: EthereumAddress
	) -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)

			firstly {
				readWeb3.eth.gasPrice()
			}.then { gasPrice in
                readWeb3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest).map { ($0, gasPrice) }
			}.then { nonce, gasPrice in
				try trxManager.createTransactionFor(
					contract: solInvoc,
					nonce: nonce,
					gasPrice: gasPrice,
					gasLimit: nil
				).promise.map { ($0, nonce, gasPrice) }
			}.then { transaction, nonce, gasPrice in
				writeWeb3.eth.estimateGas(call: .init(
					from: transaction.from,
					to: transaction.to!,
					gasPrice: gasPrice,
					data: transaction.data
				)).map { ($0, nonce, gasPrice) }

			}.done { gasLimit, nonce, gasPrice in
				let gasInfo =
					GasInfo(
						gasPrice: BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0),
						gasLimit: BigNumber(unSignedNumber: try! BigUInt(gasLimit), decimal: 0)
					)
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
            
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: walletManager.currentAccountPrivateKey.string)
            
            firstly {
                readWeb3.eth.gasPrice()
            }.then { gasPrice in
                writeWeb3.eth
                    .estimateGas(call: .init(
                        from: myPrivateKey.address,
                        to: to,
                        gasPrice: (try! BigUInt(gasPrice) * BigUInt(120) / BigUInt(100)).etherumQuantity,
                        value: value,
                        data: data
                    )).map { ($0, gasPrice) }
            }.done { estimateGas, gasPrice in
                let gasInfo =
                GasInfo(
                    gasPrice: BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0),
                    gasLimit: BigNumber(unSignedNumber: try! BigUInt(estimateGas), decimal: 0)
                )
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    
	public func calculateEthGasFee() -> Promise<GasInfo> {
		Promise<GasInfo>() { seal in
			attempt(maximumRetryCount: 3) { [self] in
				readWeb3.eth.gasPrice()
			}.done { gasPrice in
				let gasLimit = BigNumber(number: Web3Core.Constants.ethGasLimit, decimal: 0)
				let gasPriceBigNum = BigNumber(unSignedNumber: gasPrice.quantity, decimal: 0)
				let gasInfo = GasInfo(gasPrice: gasPriceBigNum, gasLimit: gasLimit)
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
					solInvoc: solInvocation,
					contractAddress: contract.address!
				)
			}.done { trxGasInfo in
				seal.fulfill(trxGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}
