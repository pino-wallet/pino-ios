//
//  W3AaveDepositManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/22/23.
//

import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveDepositManager {
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

	public func getUserUseReserveAsCollateralContractDetails(
		assetAddress: String,
		useAsCollateral: Bool
	) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.aavePoolERCContractAddress,
				abi: .borrowERCAave,
				web3: web3
			)
			let solInvocation = contract[ABIMethodWrite.setUserUseReserveAsCollateral.rawValue]?(
				assetAddress
					.eip55Address!,
				useAsCollateral
			)
			seal.fulfill(ContractDetailsModel(contract: contract, solInvocation: solInvocation!))
		}
	}

	public func setUserUseReserveAsCollateral(contractDetails: ContractDetailsModel) -> Promise<String> {
		Promise<String> { seal in
			getUserUseReserveAsCollateralTransaction(contractDetails: contractDetails)
				.then { ethereumSignedTransaction in
					web3.eth.sendRawTransaction(transaction: ethereumSignedTransaction)
				}.done { trxHash in
					seal.fulfill(trxHash.hex())
				}.catch { error in
					seal.reject(error)
				}
		}
	}

	public func getUserUseReserveAsCollateralGasInfo(contractDetails: ContractDetailsModel) -> Promise<GasInfo> {
		Promise<GasInfo> { seal in
			gasInfoManager.calculateGasOf(
				method: .borrow,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			).done { gasInfo in
				seal.fulfill(gasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getPinoAaveProxyContract() throws -> DynamicContract {
		try Web3Core.getContractOfToken(
			address: Web3Core.Constants.pinoAaveProxyAddress,
			abi: .aaveProxy,
			web3: web3
		)
	}

	public func getAaveDespositV3ERCCallData(
		contract: DynamicContract,
		assetAddress: String,
		amount: BigUInt,
		userAddress: String
	) -> Promise<String> {
		Promise<String> { seal in

			let solInvocation = contract[ABIMethodWrite.depositV3.rawValue]?(
				assetAddress.eip55Address!,
				amount,
				userAddress.eip55Address!
			)
			let trx = try trxManager.createTransactionFor(contract: solInvocation!)
			seal.fulfill(trx.data.hex())
		}
	}

	// MARK: - Private Methods

	private func getUserUseReserveAsCollateralTransaction(contractDetails: ContractDetailsModel)
		-> Promise<EthereumSignedTransaction> {
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
