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

	private lazy var swapManager: SwapManager = {
		SwapManager(
			selectedProvider: self.selectedProvider,
			srcToken: self.fromToken.selectedToken,
			destToken: self.toToken.selectedToken,
			swapAmount: self.fromToken.tokenAmount!,
			destinationAmount: self.toToken.tokenAmount!
		)
	}()

	private var swapPriceManager = SwapPriceManager()
	private var swapSide: SwapSide
	private var pendingSwapTrx: EthereumSignedTransaction?
	private var pendingSwapGasInfo: GasInfo?
	private var swapTimer: Timer?
	private var swapProvidersTimer: Timer?

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

	@Published
	public var formattedFeeInETH: String?

	@Published
	public var formattedFeeInDollar: String?

	public let swapRateTitle = "Rate"
	public let feeTitle = "Network Fee"
	public let feeInfoActionSheetTitle = "Network fee"
	public let feeInfoActionSheetDescription =
		"This is a network fee charged by Ethereum for processing your transaction. Pino does not receive any part of this fee."
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"
	public var sendStatusText: String {
		"You swapped \(fromToken.tokenAmount!.sevenDigitFormat) \(fromToken.selectedToken.symbol) to \(toToken.tokenAmount!.sevenDigitFormat) \(toToken.selectedToken.symbol)."
	}

	public var sendTransactions: [SendTransactionViewModel]? {
		guard let swapTrx = pendingSwapTrx else { return nil }
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
		swapRate: String?,
		swapSide: SwapSide,
		swapProvidersTimer: Timer?
	) {
		self.fromToken = fromToken
		self.toToken = toToken
		self.selectedProtocol = selectedProtocol
		self.selectedProvider = selectedProvider
		self.swapSide = swapSide
		self.swapRate = swapRate
		self.swapProvidersTimer = swapProvidersTimer
		setSelectedProtocol()
		recalculateSwapRate()
	}

	// MARK: - Public Methods

	public func fetchSwapInfo(completion: @escaping (Error) -> Void) {
		#warning("Waiting for amir to say is we should use this or not")
//		if let selectedProvider, let dolalarAmountBigNum = fromToken.decimalDollarAmount {
//			swapManager.getGasLimits().done { [weak self] gasLimits in
//				guard let self = self else { return }
//				let gasManager = SwapGasLimitsManager(
//					swapAmount: dolalarAmountBigNum,
//					gasLimitsModel: gasLimits,
//					isEth: fromToken.selectedToken.isEth,
//					provider: selectedProvider.provider
//				)
//				self.pendingSwapGasInfo = gasManager.gasInfo
//				self.formattedFeeInDollar = gasManager.gasInfo.feeInDollar!.priceFormat
//				self.formattedFeeInETH = gasManager.gasInfo.fee!.sevenDigitFormat
//			}.catch { error in
//				completion(error)
//			}
//		}

		swapManager.getSwapInfo().done { swapTrx, gasInfo in
			self.pendingSwapTrx = swapTrx
			self.pendingSwapGasInfo = gasInfo
			self.formattedFeeInDollar = gasInfo.feeInDollar!.priceFormat(of: .coin, withRule: .standard)
            self.formattedFeeInETH = gasInfo.fee!.sevenDigitFormat.ethFormatting
		}.catch { error in
			completion(error)
		}
	}

	public func confirmSwap(completion: @escaping () -> Void) {
		guard let pendingSwapTrx else { return }
		swapManager.confirmSwap(swapTrx: pendingSwapTrx) { trxHash in
			print("SWAP TRX HASH: \(trxHash)")
			completion()
		}
	}

	public func checkEnoughBalance() -> Bool {
		if fromToken.selectedToken.isEth {
			if pendingSwapGasInfo!.fee! > ethToken.holdAmount - fromToken.fullAmount! {
				return false
			} else {
				return true
			}
		} else {
			if pendingSwapGasInfo!.fee! > ethToken.holdAmount {
				return false
			} else {
				return true
			}
		}
	}

	public func destoryRateTimer() {
		swapTimer?.invalidate()
		swapProvidersTimer?.invalidate()
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
		swapTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] timer in
			guard let self = self else { return }
			guard let selectedProvider = selectedProvider else { return }
			swapRate = nil
			guard let srcTokenAmount = Utilities.parseToBigUInt(
				fromToken.tokenAmount!.decimalString,
				decimals: fromToken.selectedToken.decimal
			) else { return }

			swapPriceManager.getSwapResponseFrom(
				provider: selectedProvider.provider,
				srcToken: fromToken.selectedToken,
				destToken: toToken.selectedToken,
				swapSide: swapSide,
				amount: srcTokenAmount.description
			) { [self] providersInfo in

				let recalculatedSwapInfo = providersInfo.compactMap {
					SwapProviderViewModel(
						providerResponseInfo: $0,
						side: self.swapSide,
						destToken: self.toToken.selectedToken
					)
				}.first
				self.toToken.calculateDollarAmount(recalculatedSwapInfo?.swapAmount)
				self.toToken = self.toToken
				let feeVM = SwapFeeViewModel(swapProviderVM: recalculatedSwapInfo)
				feeVM.updateQuote(srcToken: self.fromToken, destToken: self.toToken)
				self.swapRate = feeVM.swapQuote
				self.swapManager = SwapManager(
					selectedProvider: recalculatedSwapInfo,
					srcToken: self.fromToken.selectedToken,
					destToken: self.toToken.selectedToken,
					swapAmount: self.fromToken.tokenAmount!,
					destinationAmount: self.toToken.tokenAmount!
				)
			}
		}
	}
}
