//
//  SwapConfirmationViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import BigInt
import Combine
import Foundation
import PromiseKit
import Web3
import Web3_Utility

class SwapConfirmationViewModel {
	// MARK: - Private Properties

	private let selectedProtocol: SwapProtocolModel
	private let selectedProvider: SwapProviderViewModel?
	private let web3 = Web3Core.shared
	private var cancellables = Set<AnyCancellable>()
	private var ethToken: AssetViewModel {
		GlobalVariables.shared.manageAssetsList!.first(where: { $0.isEth })!
	}

	private var swapPriceManager = SwapPriceManager()
	private var swapSide: SwapSide

	// MARK: - Public Properties

	public let fromToken: SwapTokenViewModel
	public let confirmButtonTitle = "Confirm"
	public let insufficientTitle = "Insufficient ETH Amount"

	public var selectedProtocolTitle: String!
	public var selectedProtocolImage: String!
	public var selectedProtocolName: String!

	@Published
	public var swapRate: String?

	@Published
	public var toToken: SwapTokenViewModel

	public lazy var swapManager: SwapManager = {
		SwapManager(
			selectedProvider: self.selectedProvider,
			srcToken: self.fromToken.selectedToken,
			destToken: self.toToken.selectedToken,
			swapAmount: self.fromToken.tokenAmount!,
			destinationAmount: self.toToken.tokenAmount!
		)
	}()

	public let swapRateTitle = "Rate"
	public let feeTitle = "Fee"
	public let feeInfoActionSheetTitle = "Network fee"
	public let feeInfoActionSheetDescription =
		"This is a network fee charged by Ethereum for processing your transaction. Pino does not receive any part of this fee."
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"
	public var sendStatusText: String {
		"You swapped \(fromToken.tokenAmount!.formattedNumberWithCamma) \(fromToken.selectedToken.symbol) to \(toToken.tokenAmount!.formattedNumberWithCamma) \(toToken.selectedToken.symbol)."
	}

	public var sendTransactions: [SendTransactionViewModel]? {
		guard let swapTrx = swapManager.pendingSwapTrx else { return nil }
		let swapTrxStatus = SendTransactionViewModel(transaction: swapTrx) { pendingActivityTXHash in
			self.swapManager.addPendingTransferActivity(trxHash: pendingActivityTXHash)
		}
		return [swapTrxStatus]
	}

	// MARK: - Initializer

	init(
		fromToken: SwapTokenViewModel,
		toToken: SwapTokenViewModel,
		selectedProtocol: SwapProtocolModel,
		selectedProvider: SwapProviderViewModel?,
		swapRate: String,
		swapSide: SwapSide
	) {
		self.fromToken = fromToken
		self.toToken = toToken
		self.selectedProtocol = selectedProtocol
		self.selectedProvider = selectedProvider
		self.swapRate = swapRate
		self.swapSide = swapSide
		setSelectedProtocol()
		recalculateSwapRate()
	}

	// MARK: - Public Methods

	public func fetchSwapInfo(completion: @escaping (Error) -> Void) {
		if let selectedProvider, let dolarAmountBigNum = fromToken.decimalDollarAmount {
			swapManager.getGasLimits().done { [weak self] gasLimits in
				guard let self = self else { return }
				let gasManager = SwapGasLimitsManager(
					swapAmount: dolarAmountBigNum,
					gasLimitsModel: gasLimits,
					isEth: fromToken.selectedToken.isEth,
					provider: selectedProvider.provider
				)
				self.swapManager.pendingSwapGasInfo = gasManager.gasInfo
				self.swapManager.formattedFeeInDollar = gasManager.gasInfo.feeInDollar!.priceFormat
				self.swapManager.formattedFeeInETH = gasManager.gasInfo.fee!.sevenDigitFormat
				swapManager.getSwapInfo(fetchedGasLimits: gasManager.gasInfo).catch { error in
					completion(error)
				}
			}.catch { error in
				completion(error)
			}
		}
	}

	public func confirmSwap(completion: @escaping () -> Void) {
		guard let pendingTrx = swapManager.pendingSwapTrx else { return }
		swapManager.confirmSwap(swapTrx: pendingTrx) { trxHash in
			print("SWAP TRX HASH: \(trxHash)")
			completion()
		}
	}

	public func checkEnoughBalance() -> Bool {
		if swapManager.pendingSwapGasInfo!.fee! > ethToken.holdAmount {
			return false
		} else {
			return true
		}
	}

	// MARK: - Private Methods

	private func setSelectedProtocol() {
		if let selectedProvider {
			selectedProtocolTitle = "Provider"
			selectedProtocolImage = selectedProvider.provider.image
			selectedProtocolName = selectedProvider.provider.name
		} else {
			selectedProtocolTitle = "Protocol"
			selectedProtocolImage = selectedProtocol.image
			selectedProtocolName = selectedProtocol.name
		}
	}

	private func recalculateSwapRate() {
		Timer.publish(every: 15, on: .main, in: .common)
			.autoconnect()
			.sink { [self] seconds in
				swapRate = nil
				guard let selectedProvider = selectedProvider else { return }
				let srcTokenAmount = Utilities.parseToBigUInt(
					fromToken.tokenAmount!,
					decimals: fromToken.selectedToken.decimal
				)
				swapPriceManager.getSwapResponseFrom(
					provider: selectedProvider.provider,
					srcToken: fromToken.selectedToken,
					destToken: toToken.selectedToken,
					swapSide: swapSide,
					amount: srcTokenAmount!.description
				) { [self] providersInfo in

					let recalculatedSwapInfo = providersInfo.compactMap {
						SwapProviderViewModel(
							providerResponseInfo: $0,
							side: swapSide,
							destToken: toToken.selectedToken
						)
					}.first
					toToken.calculateDollarAmount(recalculatedSwapInfo?.formattedSwapAmount)
					toToken = toToken
					let feeVM = SwapFeeViewModel(swapProviderVM: recalculatedSwapInfo)
					feeVM.updateQuote(srcToken: fromToken, destToken: toToken)
					swapRate = feeVM.calculatedAmount
					swapManager = SwapManager(
						selectedProvider: recalculatedSwapInfo,
						srcToken: fromToken.selectedToken,
						destToken: toToken.selectedToken,
						swapAmount: fromToken.tokenAmount!,
						destinationAmount: toToken.tokenAmount!
					)
				}
			}
			.store(in: &cancellables)
	}
}
