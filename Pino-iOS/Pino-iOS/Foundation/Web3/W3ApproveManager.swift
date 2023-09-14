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

public struct W3ApproveManager {
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

	public func approveContract(address: String, amount: BigUInt, spender: String) -> Promise<String> {
		Promise<String> { seal in
			getApproveTransaction(address: address, amount: amount, spender: spender).then { signedTrx in
				web3.eth.sendRawTransaction(transaction: signedTrx)
			}.done { trxHash in
				seal.fulfill(trxHash.hex())
			}.catch { error in
				print(error)
			}
		}
	}

	public func getApproveCallData(contractAdd: String, amount: BigUInt, spender: String) -> Promise<String> {
		Promise<String> { seal in
			getApproveTransaction(address: contractAdd, amount: amount, spender: spender).done { signedTrx in
				seal.fulfill(signedTrx.data.hex())
			}.catch { error in
				print(error)
			}
		}
	}
    
    public func getApproveProxyCallData(tokenAdd: String, spender: String) -> Promise<String> {
        Promise<String> { seal in
            let contract = try Web3Core.getContractOfToken(address: tokenAdd, abi: .swap, web3: web3)
            let solInvocation = contract[ABIMethodWrite.approveToken.rawValue]?(tokenAdd, spender)
            
            gasInfoManager.calculateGasOf(
                method: .approveToken,
                solInvoc: solInvocation!,
                contractAddress: contract.address!
            )
            .then { [self] gasInfo in
                web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
                    .map { ($0, gasInfo) }
            }
            .done { [self] nonce, gasInfo in
                
                let trx = try trxManager.createTransactionFor(
                    contract: solInvocation!,
                    nonce: nonce,
                    gasPrice: gasInfo.gasPrice.etherumQuantity,
                    gasLimit: gasInfo.gasLimit.etherumQuantity
                )
                
                let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
                seal.fulfill(signedTx.data.hex())
            }.catch { error in
                seal.reject(error)
            }
        }
    }

	// MARK: - Private Methods

	private func getApproveTransaction(
		address: String,
		amount: BigUInt,
		spender: String
	) -> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			let contract = try Web3Core.getContractOfToken(address: address, abi: .swap, web3: web3)
			let solInvocation = contract[ABIMethodWrite.approve.rawValue]?(spender, amount)

			gasInfoManager.calculateGasOf(
				method: .approve,
				solInvoc: solInvocation!,
				contractAddress: contract.address!
			)
			.then { [self] gasInfo in
				web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: solInvocation!,
					nonce: nonce,
					gasPrice: gasInfo.gasPrice.etherumQuantity,
					gasLimit: gasInfo.gasLimit.etherumQuantity
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
    
}
