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
	public let feeTitle = "Fee"
	public let feeInfoActionSheetTitle = "Fee"
	public let feeInfoActionSheetDescription = "Sample Text"
	public let feeErrorText = "Error in calculation!"
	public let feeErrorIcon = "refresh"

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
		swapManager.getSwapInfo().done { swapTrx, gasInfo in
			self.pendingSwapTrx = swapTrx
			self.pendingSwapGasInfo = gasInfo
			self.formattedFeeInDollar = gasInfo.feeInDollar!.priceFormat
			self.formattedFeeInETH = gasInfo.fee!.sevenDigitFormat
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
		if pendingSwapGasInfo!.fee! > ethToken.holdAmount {
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
		Timer.publish(every: 5, on: .main, in: .common)
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
