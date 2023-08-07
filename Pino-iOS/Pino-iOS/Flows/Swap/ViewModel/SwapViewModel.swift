//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Combine
import Foundation

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
		if swapProtocol == .bestRate {
			swapFeeVM.swapProviderVM = getBestProvider()
		}
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
		if srcToken.tokenAmount == nil {
			updateDestinationToken(destToken: destToken, tokenAmount: nil, dollarAmount: nil)
			getFeeInfo(swapResponse: nil)
		} else {
			destToken.swapDelegate.swapAmountCalculating()
			priceManager.getBestPrice(srcToken: srcToken, destToken: destToken, swapSide: swapSide) { bestResponse in
				self.updateDestinationToken(
					destToken: destToken,
					tokenAmount: bestResponse.tokenAmount,
					dollarAmount: srcToken.dollarAmount
				)
				self.getFeeInfo(swapResponse: bestResponse)
			}
		}
	}

	private func updateDestinationToken(destToken: SwapTokenViewModel, tokenAmount: String?, dollarAmount: String?) {
		destToken.setAmount(tokenAmount: tokenAmount, dollarAmount: dollarAmount)
		destToken.swapDelegate.swapAmountDidCalculate()
	}

	private func getFeeInfo(swapResponse: SwapPriceResponseProtocol?) {
		swapFeeVM.updateAmount(fromToken: fromToken, toToken: toToken)
		guard let swapResponse else { return }
		swapFeeVM.swapProviderVM = SwapProviderViewModel(provider: swapResponse.provider, swapAmount: "")
		swapFeeVM.fee = swapResponse.gasFee
		swapFeeVM.feeInDollar = swapResponse.gasFeeInDollar
	}

	private func removePreviousFeeInfo() {
		swapFeeVM.fee = nil
		swapFeeVM.feeInDollar = nil
		swapFeeVM.calculatedAmount = .emptyString
	}

	private func showBestProviderFeeInfo() {
		swapFeeVM.feeTag = .none
		swapFeeVM.priceImpact = nil
		if swapFeeVM.swapProviderVM == nil {
			swapFeeVM.swapProviderVM = getBestProvider()
		}
	}

	private func showPriceImpactFeeInfo() {
		let priceImpact = getPriceImpact()
		swapFeeVM.priceImpact = priceImpact
		swapFeeVM.feeTag = getFeeTag(priceImpact: priceImpact)
		swapFeeVM.swapProviderVM = nil
		swapFeeVM.saveAmount = nil
	}

	#warning("These values are temporary and must be replaced with network data")

	private func getBestProvider() -> SwapProviderViewModel {
		SwapProviderViewModel(provider: .oneInch, swapAmount: "")
	}

	private func getfee() -> (fee: String, feeInDollar: String) {
		let fee = "0.001"
		let feeInDollar = "1.12"
		return (fee.ethFormatting, feeInDollar.currencyFormatting)
	}

	private func getSaveAmount() -> String {
		"1"
	}

	private func getPriceImpact() -> String {
		"2"
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
