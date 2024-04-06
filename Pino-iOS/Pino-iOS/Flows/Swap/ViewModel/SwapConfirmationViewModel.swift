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
	}

	// MARK: - Public Methods

	public func fetchSwapInfo() -> Promise<Void> {
		swapManager.getSwapInfo().done { swapTrx, gasInfo in
			self.pendingSwapTrx = swapTrx
			self.pendingSwapGasInfo = gasInfo
			self.formattedFeeInDollar = gasInfo.feeInDollar!.priceFormat(of: .coin, withRule: .standard)
			self.formattedFeeInETH = gasInfo.fee!.sevenDigitFormat.ethFormatting
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
}
