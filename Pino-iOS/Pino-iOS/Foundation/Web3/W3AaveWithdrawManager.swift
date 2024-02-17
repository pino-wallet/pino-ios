//
//  W3AaveWithdrawManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/25/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveWithdrawManager: Web3HelperProtocol {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func getWithdrawMAXERCContractDetails(tokenAddress: String) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.aavePoolERCContractAddress,
				abi: .borrowERCAave,
				web3: readWeb3
			)
			let solInvocation = contract[ABIMethodWrite.withdraw.rawValue]?(
				tokenAddress.eip55Address!,
				BigNumber.maxUInt256.bigUInt,
				walletManager.currentAccount.eip55Address.eip55Address!
			)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
		}
	}

	public func getWithdrawMaxERCGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			gasInfoManager.calculateGasOf(
				method: .withdraw,
				solInvoc: contractDetails.solInvocation
			).done { gasInfo in
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getWithdrawMaxERCTransaction(contractDetails: ContractDetailsModel)
		-> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			gasInfoManager.calculateGasOf(
				method: .withdraw,
				solInvoc: contractDetails.solInvocation
			)
			.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
					.map { ($0, gasInfo) }
			}
			.done { [self] nonce, gasInfo in

				let trx = try trxManager.createTransactionFor(
					contract: contractDetails.solInvocation,
					nonce: nonce,
					gasInfo: gasInfo
				)

				let signedTx = try trx.sign(with: userPrivateKey, chainId: Web3Network.chainID)
				seal.fulfill(signedTx)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getAaveWithdrawERCCallData(
		contract: DynamicContract,
		tokenAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.withdrawV3.rawValue]?(
				tokenAddress.eip55Address!,
				amount,
				userAddress.eip55Address!
			)
			let tx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(tx.data.hex())
		}
	}

	public func getAaveUnwrapWethCallData(contract: DynamicContract) -> Promise<String> {
		Promise<String> { seal in
			let solInvocation = contract[ABIMethodWrite.unwrapWETH9.rawValue]?(
				walletManager.currentAccount.eip55Address
					.eip55Address!
			)
			let tx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(tx.data.hex())
		}
	}
}
