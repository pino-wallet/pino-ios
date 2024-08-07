//
//  WithdrawManager.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility
import Web3ContractABI

class WithdrawManager: InvestW3ManagerProtocol {
	// MARK: - Private Properties

	private var withdrawAmount: String
	private let nonce = BigNumber.bigRandomeNumber
	private let deadline = BigUInt(Date().timeIntervalSince1970 + 1_800_000) // This is the equal of 30 minutes
	private var swapManager: SwapManager?
	private let swapPriceManager = SwapPriceManager()
	private var tokenUIntNumber: BigUInt

	// MARK: - Public Properties

	public let compoundManager: CompoundWithdrawManager
	public var aaveManager: AaveWithdrawManager!
	public var withdrawTrx: EthereumSignedTransaction?
	public var withdrawGasInfo: GasInfo?
	public typealias TrxWithGasInfo = Promise<(EthereumSignedTransaction, GasInfo)>

	// MARK: - Internal properties

	internal var selectedProtocol: InvestProtocolViewModel
	internal let selectedToken: AssetViewModel
	internal var tokenPositionID: String!
	internal var cancellables = Set<AnyCancellable>()
	internal var web3 = Web3Core.shared
	internal var contract: DynamicContract
	internal var walletManager = PinoWalletManager()

	// MARK: Initializers

	init(
		contract: DynamicContract,
		selectedToken: AssetViewModel,
		withdrawProtocol: InvestProtocolViewModel,
		withdrawAmount: String
	) {
		self.contract = contract
		self.selectedToken = selectedToken
		self.selectedProtocol = withdrawProtocol
		self.withdrawAmount = withdrawAmount
		self.tokenUIntNumber = Utilities.parseToBigUInt(withdrawAmount, decimals: selectedToken.decimal)!
		self.compoundManager = CompoundWithdrawManager(
			contract: contract,
			selectedToken: selectedToken,
			withdrawAmount: withdrawAmount
		)
	}

	// MARK: Public Methods

	public func getWithdrawInfo(withdrawType: WithdrawMode) -> TrxWithGasInfo {
		switch selectedProtocol {
		case .maker:
			return getMakerWithdrawInfo(withdrawType: withdrawType)
		case .compound:
			return compoundManager.getWithdrawInfo(withdrawType: withdrawType)
		case .lido:
			return getLidoWithdrawInfo(withdrawType: withdrawType)
		case .aave:
			return getAaveWithdrawInfo(withdrawType: withdrawType)
		}
	}

	// MARK: - Private Methods

	private func getMakerWithdrawInfo(withdrawType: WithdrawMode) -> TrxWithGasInfo {
		switch withdrawType {
		case .decrease:
			return getMakerDecreaseInfo()
		case .withdrawMax:
			return getMakerWithdrawMaxInfo()
		}
	}

	private func getMakerDecreaseInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getSDaiToDaiCallData(
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData) }
			}.then { protocolCallData, permitData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { withdrawResult in
				self.withdrawTrx = withdrawResult.0
				self.withdrawGasInfo = withdrawResult.1
				seal.fulfill(withdrawResult)
			}.catch { error in
				print("W3 Error: getting Maker withdraw info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func getMakerWithdrawMaxInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				let positionAsset = GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == positionID })
				self.tokenUIntNumber = positionAsset!.holdAmount.bigUInt
				return self.fetchHash()
			}.then { plainHash in
				self.signHash(plainHash: plainHash)
			}.then { signiture -> Promise<String> in
				// Permit Transform
				self.getProxyPermitTransferData(signiture: signiture)
			}.then { [self] permitData -> Promise<(String, String)> in
				web3.getSDaiToDaiCallData(
					amount: tokenUIntNumber,
					recipientAdd: walletManager.currentAccount.eip55Address
				).map { ($0, permitData) }
			}.then { protocolCallData, permitData in
				// MultiCall
				let callDatas = [permitData, protocolCallData]
				return self.callProxyMultiCall(data: callDatas, value: nil)
			}.done { withdrawResult in
				self.withdrawTrx = withdrawResult.0
				self.withdrawGasInfo = withdrawResult.1
				seal.fulfill(withdrawResult)
			}.catch { error in
				print(error.localizedDescription)
			}
		}
	}

	private func getLidoWithdrawInfo(withdrawType: WithdrawMode) -> TrxWithGasInfo {
		switch withdrawType {
		case .decrease:
			getLidoDecreaseInfo()
		case .withdrawMax:
			getLidoWithdrawMaxInfo()
		}
	}

	private func getLidoDecreaseInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.getSTETHToETHSwapInfo()
			}.done { trx, gasInfo in
				seal.fulfill((trx, gasInfo))
			}.catch { error in
				print("W3 Error: getting Lido withdraw info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func getLidoWithdrawMaxInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				let positionAsset = GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == positionID })
				self.tokenUIntNumber = positionAsset!.holdAmount.bigUInt
				return self.getSTETHToETHSwapInfo()
			}.done { trx, gasInfo in
				seal.fulfill((trx, gasInfo))
			}.catch { error in
				print("W3 Error: getting Lido withdraw info: \(error)")
				seal.reject(error)
			}
		}
	}

	private func getSTETHToETHSwapInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			let stethToken = selectedToken.copy(newId: tokenPositionID)
			firstly {
				getSTETHToETHBestPrice(stethToken)
			}.then { bestPriceProvider in
				let swapAmountBigNumber = BigNumber(unSignedNumber: self.tokenUIntNumber, decimal: stethToken.decimal)
				self.swapManager = SwapManager(
					selectedProvider: bestPriceProvider,
					srcToken: stethToken,
					destToken: self.selectedToken,
					swapAmount: swapAmountBigNumber,
					destinationAmount: bestPriceProvider.swapAmount
				)
				return self.swapManager!.getSwapInfo()
			}.done { trxWithGasInfo in
				self.withdrawTrx = trxWithGasInfo.0
				self.withdrawGasInfo = trxWithGasInfo.1
				seal.fulfill(trxWithGasInfo)
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getSTETHToETHBestPrice(_ stethToken: AssetViewModel) -> Promise<SwapProviderViewModel> {
		Promise<SwapProviderViewModel> { seal in
			let swapInfo = SwapPriceRequestModel(
				srcToken: stethToken.id,
				srcDecimals: stethToken.decimal,
				destToken: selectedToken.id,
				destDecimals: selectedToken.decimal,
				amount: tokenUIntNumber.description,
				side: .sell,
				userAddress: Web3Core.Constants.pinoSwapProxyAddress,
				receiver: walletManager.currentAccount.eip55Address
			)
			swapPriceManager.getLidoProvidersPrice(swapInfo: swapInfo).done { [weak self] priceResponce in
				guard let self else { return }
				let providers = priceResponce.compactMap {
					SwapProviderViewModel(providerResponseInfo: $0, side: .sell, destToken: self.selectedToken)
				}.sorted { $0.swapAmount > $1.swapAmount }
				if let bestPriceProvider = providers.first {
					seal.fulfill(bestPriceProvider)
				} else {
					seal.reject(Web3Error.providerError)
				}
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getAaveWithdrawInfo(withdrawType: WithdrawMode) -> TrxWithGasInfo {
		firstly {
			getTokenPositionID()
		}.then { [self] tokenPositionId in
			let tokenPosition = GlobalVariables.shared.manageAssetsList!
				.first(where: { $0.id.lowercased() == tokenPositionId.lowercased() })!
			aaveManager = AaveWithdrawManager(
				contract: contract,
				asset: selectedToken,
				assetAmount: withdrawAmount,
				positionAsset: tokenPosition
			)
			switch withdrawType {
			case .decrease:
				return aaveManager.getWithdrawInfo()
			case .withdrawMax:
				return aaveManager.getWithdrawMaxInfo()
			}
		}
	}

	private func fetchHash() -> Promise<String> {
		Promise<String> { seal in
			let hashREq = EIP712HashRequestModel(
				tokenAdd: tokenPositionID,
				amount: tokenUIntNumber.description,
				spender: contract.address!.hex(eip55: true),
				nonce: nonce.description,
				deadline: deadline.description
			)

			web3Client.getHashTypedData(eip712HashReqInfo: hashREq.eip712HashReqBody).sink { completed in
				switch completed {
				case .finished:
					print("User hash received successfully")
				case let .failure(error):
					print("Error: getting user hash: \(error)")
					seal.reject(error)
				}
			} receiveValue: { hashResponse in
				seal.fulfill(hashResponse.hash)
			}.store(in: &cancellables)
		}
	}

	private func callProxyMultiCall(data: [String], value: BigUInt?) -> Promise<(EthereumSignedTransaction, GasInfo)> {
		web3.callMultiCall(
			contractAddress: contract.address!.hex(eip55: true),
			callData: data,
			value: value ?? 0.bigNumber.bigUInt
		)
	}

	// MARK: Internal Methods

	internal func getProxyPermitTransferData(signiture: String) -> Promise<String> {
		web3.getPermitTransferCallData(
			contract: contract,
			amount: tokenUIntNumber,
			tokenAdd: tokenPositionID,
			signiture: signiture,
			nonce: nonce,
			deadline: deadline
		)
	}
}
