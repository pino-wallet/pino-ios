//
//  CollateralManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 10/22/23.
//

import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class AaveCollateralManager: Web3ManagerProtocol {
	// MARK: - TypeAliases

	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Private Properties

	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes in ms
	private let nonce = BigNumber.bigRandomeNumber
	private let web3Client = Web3APIClient()
	private var asset: AssetViewModel
	private var assetAmountBigNumber: BigNumber
    private var assetAmountBigUInt: BigUInt
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Internal Properties

	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var depositGasInfo: GasInfo?
    public var depositTRX: EthereumSignedTransaction?
    #warning("i should use this to create tx")
    public var useUserReserveAsCollateralContractDetails: ContractDetailsModel?

	// MARK: - Initializers

	init(contract: DynamicContract, asset: AssetViewModel, assetAmount: String) {
		if asset.isEth {
			self.asset = (GlobalVariables.shared.manageAssetsList?.first(where: { $0.isWEth }))!
		} else {
			self.asset = asset
		}
		self.assetAmountBigNumber = BigNumber(numberWithDecimal: assetAmount)
        self.assetAmountBigUInt = Utilities.parseToBigUInt(assetAmount, decimals: asset.decimal)!
		self.contract = contract
	}

	// MARK: - Internal Methods

	func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract, amount: assetAmountBigUInt,
			tokenAdd: asset.id,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}

	// MARK: - Private Methods

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in

			let hashREq = EIP712HashRequestModel(
				tokenAdd: asset.id,
				amount:
				assetAmountBigUInt.description,
				spender: contract.address!.hex(eip55: true),
				nonce: nonce.description,
				deadline: deadline.description
			)

			web3Client.getHashTypedData(eip712HashReqInfo: hashREq).sink { completed in
				switch completed {
				case .finished:
					print("Info received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { hashResponse in
				seal.fulfill(hashResponse.hash)
			}.store(in: &cancellables)
		}
	}

	func signHash(plainHash: String) -> Promise<String> {
		Promise<String> { seal in
			var signiture = try Sec256k1Encryptor.sign(
				msg: plainHash.hexToBytes(),
				seckey: walletManager.currentAccountPrivateKey.string.hexToBytes()
			)
			signiture[signiture.count - 1] += 27

			seal.fulfill("0x\(signiture.toHexString())")
		}
	}

	private func getAaveDespositV3ERCCallData() -> Promise<String> {
		web3.getAaveDespositV3ERCCallData(
			contract: contract,
			assetAddress: asset.id,
			amount: assetAmountBigUInt,
			userAddress: walletManager.currentAccount.eip55Address
		)
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}
	

	// MARK: - Public Methods
    
    public func confirmDeposit(completion: @escaping (Result<String>) -> Void) {
        guard let depositTRX else { return }
        web3.callTransaction(trx: depositTRX).done { trxHash in
            #warning("i should add pending activity here")
            #warning("i should send useUserResrverAsCollateral tx here")
            completion(.fulfilled(trxHash))
        }.catch { error in
            completion(.rejected(error))
        }
    }
    
    public func getUserUseReserveAsCollateralData() -> Promise<GasInfo> {
        Promise<GasInfo> { seal in
            web3.getUserUseReserveAsCollateralContractDetails(assetAddress: asset.id, useAsCollateral: true).done { contractDetails in
                self.useUserReserveAsCollateralContractDetails = contractDetails
                self.web3.getUserUseReserveAsCollateralGasInfo(contractDetails: contractDetails).done { gasInfo in
                    seal.fulfill(gasInfo)
                }.catch { error in
                    seal.reject(error)
                }
            }.catch { error in
                seal.reject(error)
            }
        }
    }

	public func getERC20CollateralData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<(String, String?)> in
				self.checkAllowanceOfProvider(
					approvingToken: self.asset,
					approvingAmount: self.assetAmountBigNumber.sevenDigitFormat,
					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
				).map {
					(signiture, $0)
				}
			}.then { signiture, allowanceData -> Promise<(String, String?)> in
				self.getProxyPermitTransferData(signiture: signiture).map { ($0, allowanceData) }
			}.then { permitData, allowanceData -> Promise<(String, String, String?)> in
				self.getAaveDespositV3ERCCallData().map {
					($0, permitData, allowanceData)
				}
			}.then { depositData, permitData, allowanceData in
				var multiCallData: [String] = [permitData, depositData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
				return self.callProxyMultiCall(data: multiCallData, value: nil)
			}.done { depositResults in
				self.depositTRX = depositResults.0
				self.depositGasInfo = depositResults.1
				seal.fulfill(depositResults)
			}.catch { error in
				print(error)
			}
		}
	}

	public func getETHCollateralData() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				self.checkAllowanceOfProvider(
					approvingToken: self.asset,
					approvingAmount: self.assetAmountBigNumber.sevenDigitFormat,
					spenderAddress: Web3Core.Constants.aavePoolERCContractAddress
				)
			}.then { allowanceData -> Promise<(String, String?)> in
				self.wrapTokenCallData().map { ($0, allowanceData) }
			}.then { wrapETHData, allowanceData -> Promise<(String, String, String?)> in
				self.getAaveDespositV3ERCCallData().map { ($0, wrapETHData, allowanceData) }
			}.then { depositData, wrapETHData, allowanceData in
				var multiCallData: [String] = [wrapETHData, depositData]
				if let allowanceData { multiCallData.insert(allowanceData, at: 0) }
                return self.callProxyMultiCall(data: multiCallData, value: self.assetAmountBigUInt)
			}.done { depositResults in
				self.depositTRX = depositResults.0
				self.depositGasInfo = depositResults.1
				seal.fulfill(depositResults)
			}.catch { error in
				print(error)
			}
		}
	}
}
