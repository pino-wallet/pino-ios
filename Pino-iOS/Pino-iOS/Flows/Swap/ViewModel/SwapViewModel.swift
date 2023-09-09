//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation
import Web3_Utility

class SwapViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedProtocol: SwapProtocolModel

	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let switchIcon = "switch_swap"

	public var fromToken: SwapTokenViewModel
	public var toToken: SwapTokenViewModel

	public var swapFeeVM: SwapFeeViewModel

	public var providers: [SwapProviderViewModel] = []
	public var bestProvider: SwapProviderViewModel?

	// MARK: - Private Properties

	private let priceManager = SwapPriceManager()

	private var swapSide: SwapSide? {
		if !fromToken.isEditing && !toToken.isEditing {
			return .sell
		} else if fromToken.isEditing {
			return .sell
		} else if toToken.isEditing {
			return .buy
		} else {
			return nil
		}
	}

	// MARK: - Initializers

	init(fromToken: AssetViewModel, toToken: AssetViewModel) {
		self.selectedProtocol = .bestRate
		self.fromToken = SwapTokenViewModel(selectedToken: fromToken)
		self.toToken = SwapTokenViewModel(selectedToken: toToken)
		self.swapFeeVM = SwapFeeViewModel()

		self.fromToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.toToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {
		token.selectedToken = newToken
		recalculateTokensAmount()
		token.swapDelegate.selectedTokenDidChange()
	}

	public func switchTokens() {
		let selectedFromToken = fromToken.selectedToken
		fromToken.selectedToken = toToken.selectedToken
		toToken.selectedToken = selectedFromToken

		let fromTokenAmount = fromToken.tokenAmount
		fromToken.tokenAmount = toToken.tokenAmount
		toToken.tokenAmount = fromTokenAmount

		recalculateTokensAmount()

		fromToken.swapDelegate.selectedTokenDidChange()
		toToken.swapDelegate.selectedTokenDidChange()
	}

	public func changeSwapProtocol(to swapProtocol: SwapProtocolModel) {
		selectedProtocol = swapProtocol
		recalculateTokensAmount()
	}

	public func changeSwapProvider(to swapProvider: SwapProviderViewModel) {
		getSwapSide { side, srcToken, destToken in
			swapFeeVM.swapProviderVM = swapProvider
			updateDestinationToken(destToken: destToken, tokenAmount: swapProvider.formattedSwapAmount)
			getFeeInfo(swapProvider: swapProvider)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String?) {
		getSwapSide { side, srcToken, destToken in
			getSwapAmount(srcToken: srcToken, destToken: destToken, amount: amount, swapSide: side)
		}
	}

	private func recalculateTokensAmount() {
		getSwapSide { side, srcToken, destToken in
			getSwapAmount(srcToken: srcToken, destToken: destToken, amount: srcToken.tokenAmount, swapSide: side)
		}
	}

	private func getSwapAmount(
		srcToken: SwapTokenViewModel,
		destToken: SwapTokenViewModel,
		amount: String?,
		swapSide: SwapSide
	) {
		srcToken.calculateDollarAmount(amount)
		guard let tokenAmount = srcToken.tokenAmount else {
			removeDestinationAmount(destToken)
		}
		let swapAmount = Utilities.parseToBigUInt(tokenAmount, units: .custom(srcToken.selectedToken.decimal))
		if let swapAmount, !swapAmount.isZero {
			getDestinationAmount(destToken, swapAmount: swapAmount.description, swapSide: swapSide)
		} else {
			removeDestinationAmount(destToken)
		}
	}

	private func getDestinationAmount(_ destToken: SwapTokenViewModel, swapAmount: String, swapSide: SwapSide) {
		removePreviousFeeInfo()
		destToken.swapDelegate.swapAmountCalculating()
		getSwapProviderInfo(destToken: destToken.selectedToken, amount: swapAmount, swapSide: swapSide) { swapAmount in
			self.updateDestinationToken(destToken: destToken, tokenAmount: swapAmount)
		}
	}

	private func removeDestinationAmount(_ destToken: SwapTokenViewModel) {
		priceManager.cancelPreviousRequests()
		updateDestinationToken(destToken: destToken, tokenAmount: nil)
		getFeeInfo(swapProvider: nil)
	}

	private func getSwapProviderInfo(
		destToken: AssetViewModel,
		amount: String,
		swapSide: SwapSide,
		completion: @escaping (String) -> Void
	) {
		if selectedProtocol == .bestRate {
			getBestRate(destToken: destToken, amount: amount, swapSide: swapSide, completion: completion)
		} else {
			#warning("The price of other protocols must be taken here")
		}
	}

	private func getBestRate(
		destToken: AssetViewModel,
		amount: String,
		swapSide: SwapSide,
		completion: @escaping (String) -> Void
	) {
		priceManager.getBestPrice(srcToken: fromToken, destToken: toToken, swapSide: swapSide, amount: amount)
			{ providersInfo in
				self.providers = providersInfo.compactMap {
					SwapProviderViewModel(providerResponseInfo: $0, side: swapSide, destToken: destToken)
				}.sorted { $0.swapAmount > $1.swapAmount }
				let bestProvider = self.providers.first!
				self.bestProvider = bestProvider
				completion(bestProvider.formattedSwapAmount)
				self.getFeeInfo(swapProvider: bestProvider)
			}
	}

	private func updateDestinationToken(destToken: SwapTokenViewModel, tokenAmount: String?) {
		destToken.calculateDollarAmount(tokenAmount)
		destToken.swapDelegate.swapAmountDidCalculate()
	}

	private func getSwapSide(
		completion: (_ side: SwapSide, _ srcToken: SwapTokenViewModel, _ destToken: SwapTokenViewModel) -> Void
	) {
		guard let swapSide else { return }
		switch swapSide {
		case .sell:
			completion(.sell, fromToken, toToken)
		case .buy:
			completion(.buy, toToken, fromToken)
		}
	}

	private func getFeeInfo(swapProvider: SwapProviderViewModel?) {
		swapFeeVM.updateQuote(srcToken: fromToken, destToken: toToken)
		guard let swapProvider else { return }
		swapFeeVM.swapProviderVM = swapProvider
		updateBestRateTag()
		swapFeeVM.fee = swapProvider.fee
		swapFeeVM.feeInDollar = swapProvider.feeInDollar
	}

	private func removePreviousFeeInfo() {
		swapFeeVM.fee = nil
		swapFeeVM.feeInDollar = nil
		swapFeeVM.calculatedAmount = .emptyString
	}

	private func getFeeTag(saveAmount: String) -> SwapFeeViewModel.FeeTag {
		if BigNumber(numberWithDecimal: saveAmount) > BigNumber(number: 0, decimal: 0) {
			return .save("\(saveAmount.currencyFormatting) \(swapFeeVM.celebrateEmoji)")
		} else {
			return .none
		}
	}

	private func getFeeTag(priceImpact: String) -> SwapFeeViewModel.FeeTag {
		if BigNumber(numberWithDecimal: priceImpact) > BigNumber(number: 1, decimal: 0) {
			return .highImpact
		} else {
			return .none
		}
	}

	private func updateBestRateTag() {
		if swapFeeVM.swapProviderVM?.provider == bestProvider?.provider {
			swapFeeVM.isBestRate = true
		} else {
			swapFeeVM.isBestRate = false
		}
	}
}
