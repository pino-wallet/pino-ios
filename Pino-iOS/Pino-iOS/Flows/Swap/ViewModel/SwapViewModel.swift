//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

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

	// MARK: - Initializers

	init(fromToken: AssetViewModel, toToken: AssetViewModel) {
		self.selectedProtocol = .bestRate
		self.fromToken = SwapTokenViewModel(selectedToken: fromToken)
		self.toToken = SwapTokenViewModel(selectedToken: toToken)
		self.swapFeeVM = SwapFeeViewModel(swapProvider: .oneInch)

		self.fromToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.toToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String? = nil) {
		if toToken.isEditing {
			toToken.calculateDollarAmount(amount ?? toToken.tokenAmount)
			fromToken.calculateTokenAmount(decimalDollarAmount: toToken.decimalDollarAmount)
			fromToken.swapDelegate.swapAmountDidCalculate()
		} else if fromToken.isEditing {
			fromToken.calculateDollarAmount(amount ?? fromToken.tokenAmount)
			toToken.calculateTokenAmount(decimalDollarAmount: fromToken.decimalDollarAmount)
			toToken.swapDelegate.swapAmountDidCalculate()
		}
		updateCalculatedAmount()
		getFeeInfo()
	}

	private func updateCalculatedAmount() {
		if let fromTokenAmount = fromToken.formattedTokenAmount, let toTokenAmount = toToken.formattedTokenAmount {
			swapFeeVM.calculatedAmount = "\(fromTokenAmount) = \(toTokenAmount)"
		} else {
			swapFeeVM.calculatedAmount = nil
		}
	}

	private func getFeeInfo() {
		// This values are temporary and must be replaced with network data
		let swapFee = "0.001"
		let saveAmount = "1"

		swapFeeVM.fee = swapFee
		swapFeeVM.saveAmount = saveAmount
		if let saveAmountDecimalNumber = Decimal(string: saveAmount), saveAmountDecimalNumber > 0 {
			swapFeeVM.feeTag = .save("$\(saveAmount) \(swapFeeVM.celebrateEmoji)")
		} else {
			swapFeeVM.feeTag = .none
		}
	}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {
		if !fromToken.isEditing, !toToken.isEditing {
			token.isEditing = true
		}
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
}
