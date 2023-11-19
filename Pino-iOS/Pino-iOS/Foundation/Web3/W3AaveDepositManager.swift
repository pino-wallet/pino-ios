//
//  W3AaveDepositManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/22/23.
//

import BigInt
import Foundation
import PromiseKit
import Web3
import Web3ContractABI

public struct W3AaveDepositManager: Web3Manager {
	// MARK: - Internal Properties

	var writeWeb3: Web3
	var readWeb3: Web3

	// MARK: - Initializer

	init(writeWeb3: Web3, readWeb3: Web3) {
		self.readWeb3 = readWeb3
		self.writeWeb3 = writeWeb3
	}

	// MARK: - Public Methods

	public func checkIfAssetUsedAsCollateral(assetAddress: String) -> Promise<Bool> {
		Promise<Bool> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.aavePoolERCContractAddress,
				abi: .borrowERCAave,
				web3: readWeb3
			)
			let reserveListSolInvocation = contract[ABIMethodCall.getReservesList.rawValue]?()
			let getUserConfigurationSolInvocation = contract[ABIMethodCall.getUserConfiguration.rawValue]?(
				walletManager
					.currentAccount.eip55Address.eip55Address!
			)
			reserveListSolInvocation?.call().done { result in
				if let reserveTokensList = result.first?.value as? [EthereumAddress] {
					getUserConfigurationSolInvocation?.call().done { configuration in
						if let configurationDictionary = configuration.first?.value as? [String: Any] {
							if let configurationNumber = configurationDictionary["data"] as? BigUInt {
								let configurationBinaryString = String(configurationNumber, radix: 2)
								let checkIsAssetCollateralledResult = checkIsCollateralledAsset(
									reserveList: reserveTokensList,
									configurationBinaryString: configurationBinaryString,
									assetAddress: (assetAddress.eip55Address?.hex(eip55: true))!
								)
								seal.fulfill(checkIsAssetCollateralledResult)
							}
						}
					}.catch { error in
						seal.reject(error)
					}
				}
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	public func getUserUseReserveAsCollateralContractDetails(
		assetAddress: String,
		useAsCollateral: Bool
	) -> Promise<ContractDetailsModel> {
		Promise<ContractDetailsModel> { seal in
			let contract = try Web3Core.getContractOfToken(
				address: Web3Core.Constants.aavePoolERCContractAddress,
				abi: .borrowERCAave,
				web3: readWeb3
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
					writeWeb3.eth.sendRawTransaction(transaction: ethereumSignedTransaction)
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
				method: .setUserUseReserveAsCollateral,
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
			web3: readWeb3
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

	private func checkIsCollateralledAsset(
		reserveList: [EthereumAddress],
		configurationBinaryString: String,
		assetAddress: String
	) -> Bool {
		var result = false

		if configurationBinaryString == "0" {
			return result
		}

		var enabledCollateralList: [Bool] = []
		for index in stride(from: configurationBinaryString.count - 1, through: 0, by: -2) {
			if (index + 1) % 2 == 0 {
				if index - 1 < 0 {
					enabledCollateralList.append(false)
					continue
				}

				let stringIndex = configurationBinaryString.index(
					configurationBinaryString.startIndex,
					offsetBy: index - 1
				)
				if configurationBinaryString[stringIndex] == "1" {
					enabledCollateralList.append(true)
					continue
				}

				enabledCollateralList.append(false)
			}
		}
		guard let foundAssetIndexInReserveList = reserveList
			.firstIndex(where: { $0.hex(eip55: true) == assetAddress.eip55Address?.hex(eip55: true) }) else {
			return result
		}

		guard foundAssetIndexInReserveList <= enabledCollateralList.count - 1 else {
			return result
		}

		if enabledCollateralList[foundAssetIndexInReserveList] {
			result = true
		}

		return result
	}

	private func getUserUseReserveAsCollateralTransaction(contractDetails: ContractDetailsModel)
		-> Promise<EthereumSignedTransaction> {
		Promise<EthereumSignedTransaction> { seal in

			gasInfoManager.calculateGasOf(
				method: .setUserUseReserveAsCollateral,
				solInvoc: contractDetails.solInvocation,
				contractAddress: contractDetails.contract.address!
			)
			.then { [self] gasInfo in
				readWeb3.eth.getTransactionCount(address: userPrivateKey.address, block: .latest)
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
