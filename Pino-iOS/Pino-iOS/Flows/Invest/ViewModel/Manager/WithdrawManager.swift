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
	private var swapTrx: EthereumSignedTransaction?
	private var tokenUIntNumber: BigUInt {
		Utilities.parseToBigUInt(withdrawAmount, decimals: selectedToken.decimal)!
	}

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
		self.compoundManager = CompoundWithdrawManager(
			contract: contract,
			selectedToken: selectedToken,
			withdrawAmount: withdrawAmount
		)
	}

	// MARK: Public Methods

	public func getWithdrawInfo() -> TrxWithGasInfo {
		switch selectedProtocol {
		case .maker:
			return getMakerWithdrawInfo()
		case .compound:
			return compoundManager.getWithdrawInfo()
		case .lido:
			return getLidoWithdrawInfo()
		case .aave:
			return getAaveWithdrawInfo()
		}
	}

	// MARK: - Private Methods

	private func getMakerWithdrawInfo() -> TrxWithGasInfo {
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
				print(error.localizedDescription)
			}
		}
	}

	private func getLidoWithdrawInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			firstly {
				getTokenPositionID()
			}.then { positionID in
				self.getSTETHToETHSwapInfo()
			}.done { trx, gasInfo in
				seal.fulfill((trx, gasInfo))
			}.catch { error in
				seal.reject(error)
			}
		}
	}

	private func getSTETHToETHSwapInfo() -> TrxWithGasInfo {
		TrxWithGasInfo { seal in
			let stethToken = selectedToken.copy(newId: tokenPositionID)
			swapPriceManager.getSwapResponseFrom(
				provider: .paraswap,
				srcToken: stethToken,
				destToken: selectedToken,
				swapSide: .sell,
				amount: tokenUIntNumber.description
			) { priceResponce in
				self.swapManager = SwapManager(
					selectedProvider: SwapProviderViewModel(
						providerResponseInfo: priceResponce.first!,
						side: .sell,
						destToken: self.selectedToken
					),
					srcToken: stethToken,
					destToken: self.selectedToken,
					swapAmount: self.withdrawAmount,
					destinationAmount: priceResponce.first!.destAmount
				)
//				self.swapManager!.getSwapInfo().done { trxWithGasInfo in
//					self.swapTrx = trxWithGasInfo.0
//					seal.fulfill(trxWithGasInfo)
//				}.catch { error in
//					seal.reject(error)
//				}
			}
		}
	}

	private func getAaveWithdrawInfo() -> TrxWithGasInfo {
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
			return aaveManager.getWithdrawInfo()
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
					print("Info received successfully")
				case let .failure(error):
					print(error)
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
