//
//  W3AaveBorrowManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/10/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveBorrowManager {
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
    public func getERCBorrowContractDetails(tokenID: String, amount: BigInt, userAddress: String) -> Promise<ContractDetailsModel> {
        Promise<ContractDetailsModel> { seal in
            let contract = try Web3Core.getContractOfToken(address: Web3Core.Constants.aaveERCContractAddress, abi: .borrowERCAave, web3: web3)
            let solInvocation = contract[ABIMethodWrite.borrow.rawValue]?(tokenID, amount, Web3Core.Constants.aaveBorrowVariableInterestRate, Web3Core.Constants.aaveBorrowReferralCode, userAddress)
            seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
        }
    }
    
    public func getETHBorrowContractDetails(amount: BigInt) -> Promise<ContractDetailsModel> {
        Promise<ContractDetailsModel> { seal in
            let contract = try Web3Core.getContractOfToken(address: Web3Core.Constants.aaveETHContractAddress, abi: .borrowETHAave, web3: web3)
//            let solInvocation = contract[ABIMethodWrite.borrowETH.rawValue]?(Web3Core.Constants.aaveERCContractAddress, amount, Web3Core.Constants.aaveBorrowVariableInterestRate, Web3Core.Constants.aaveBorrowReferralCode)
//            seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
        }
    }
    
    public func getERCBorrowGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
        Promise<GasInfo> { seal in
            gasInfoManager.calculateGasOf(method: .borrow, solInvoc: contractDetails.solInvocation, contractAddress: contractDetails.contract.address!).done { gasInfo in
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    public func getETHBorrowGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
        Promise<GasInfo> { seal in
            gasInfoManager.calculateGasOf(method: .borrowETH, solInvoc: contractDetails.solInvocation, contractAddress: contractDetails.contract.address!).done { gasInfo in
                seal.fulfill(gasInfo)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    public func borrowToken(contractDetails: ContractDetailsModel) -> Promise<String> {
        Promise<String> { seal in
            getBorrowTransaction(contractDetails: contractDetails).then { ethereumSignedTransaction in
                web3.eth.sendRawTransaction(transaction: ethereumSignedTransaction)
            }.done { trxHash in
                seal.fulfill(trxHash.hex())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    
    // MARK: - Private Methods
    private func getBorrowTransaction(contractDetails: ContractDetailsModel) -> Promise<EthereumSignedTransaction> {
        Promise<EthereumSignedTransaction> { seal in

            gasInfoManager.calculateGasOf(
                method: .borrow,
                solInvoc: contractDetails.solInvocation,
                contractAddress: contractDetails.contract.address!
            )
            .then { [self] gasInfo in
                web3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
                    .map { ($0, gasInfo) }
            }
            .done { [self] nonce, gasInfo in

                let trx = try trxManager.createTransactionFor(
                    contract: contractDetails.solInvocation,
                    nonce: nonce,
                    gasPrice: gasInfo.gasPrice.etherumQuantity,
                    gasLimit: gasInfo.increasedGasLimit.etherumQuantity
                )

                let signedTx = try trx.sign(with: userPrivateKey, chainId: 1)
                seal.fulfill(signedTx)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

  
}

