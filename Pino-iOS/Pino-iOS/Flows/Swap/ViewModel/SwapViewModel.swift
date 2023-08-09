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

	// MARK: - Private Properties

	private let priceManager = SwapPriceManager()

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
		swapFeeVM.swapProviderVM = swapProvider
		recalculateTokensAmount()
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String? = nil) {
		if !fromToken.isEditing && !toToken.isEditing {
			getSwapAmount(srcToken: fromToken, destToken: toToken, amount: amount, swapSide: .sell)
		} else if fromToken.isEditing {
			getSwapAmount(srcToken: fromToken, destToken: toToken, amount: amount, swapSide: .sell)
		} else if toToken.isEditing {
			getSwapAmount(srcToken: toToken, destToken: fromToken, amount: amount, swapSide: .buy)
		}
	}

	private func getSwapAmount(
		srcToken: SwapTokenViewModel,
		destToken: SwapTokenViewModel,
		amount: String?,
		swapSide: SwapSide
	) {
		removePreviousFeeInfo()
		srcToken.calculateDollarAmount(amount)
		if let tokenAmount = srcToken.tokenAmount {
			destToken.swapDelegate.swapAmountCalculating()
			let swapAmount = Utilities.parseToBigUInt(tokenAmount, units: .custom(srcToken.selectedToken.decimal))
			getSwapProviderInfo(
				destToken: destToken.selectedToken,
				amount: swapAmount!.description,
				swapSide: swapSide
			) { swapAmount in
				self.updateDestinationToken(
					destToken: destToken,
					tokenAmount: swapAmount,
					dollarAmount: srcToken.dollarAmount
				)
			}
		} else {
			updateDestinationToken(destToken: destToken, tokenAmount: nil, dollarAmount: nil)
			getFeeInfo(swapProvider: nil)
		}
	}

	private func getSwapProviderInfo(
		destToken: AssetViewModel,
		amount: String,
		swapSide: SwapSide,
		completion: @escaping (String) -> Void
	) {
		if selectedProtocol == .bestRate {
			priceManager.getBestPrice(
				srcToken: fromToken,
				destToken: toToken,
				swapSide: swapSide,
				amount: amount
			) { providersInfo in
				self.providers = providersInfo.compactMap {
					SwapProviderViewModel(providerResponseInfo: $0, side: swapSide, destToken: destToken)
				}.sorted { $0.swapAmount < $1.swapAmount }
				let bestProvider = self.providers.first!
				completion(bestProvider.formattedSwapAmount)
				self.getFeeInfo(swapProvider: bestProvider)
			}
		} else {
			// Implement later
		}
	}

	private func updateDestinationToken(destToken: SwapTokenViewModel, tokenAmount: String?, dollarAmount: String?) {
		destToken.setAmount(tokenAmount: tokenAmount, dollarAmount: dollarAmount)
		destToken.swapDelegate.swapAmountDidCalculate()
	}

	private func getFeeInfo(swapProvider: SwapProviderViewModel?) {
		swapFeeVM.updateQout(srcToken: fromToken, destToken: toToken)
		guard let swapProvider else { return }
		swapFeeVM.swapProviderVM = swapProvider
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
}
