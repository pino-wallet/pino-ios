//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation

class SwapViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Swap"
	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let switchIcon = "switch_swap"

	public var payToken: SwapTokenViewModel
	public var getToken: SwapTokenViewModel

	// MARK: - Initializers

	init(payToken: AssetViewModel, getToken: AssetViewModel) {
		self.payToken = SwapTokenViewModel(selectedToken: payToken)
		self.getToken = SwapTokenViewModel(selectedToken: getToken)

		self.payToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.getToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String? = nil) {
		if getToken.isEditing {
			getToken.calculateDollarAmount(amount ?? getToken.tokenAmount)
			payToken.calculateTokenAmount(decimalDollarAmount: getToken.decimalDollarAmount)
			payToken.delegate.swapAmountDidCalculate()
		} else {
			payToken.calculateDollarAmount(amount ?? payToken.tokenAmount)
			getToken.calculateTokenAmount(decimalDollarAmount: payToken.decimalDollarAmount)
			getToken.delegate.swapAmountDidCalculate()
		}
	}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {
		token.selectedToken = newToken
		recalculateTokensAmount()
		token.delegate.selectedTokenDidChange()
	}

	public func switchTokens() {
		let selectedPayToken = payToken.selectedToken
		payToken.selectedToken = getToken.selectedToken
		getToken.selectedToken = selectedPayToken

		let payTokenAmount = payToken.tokenAmount
		payToken.tokenAmount = getToken.tokenAmount
		getToken.tokenAmount = payTokenAmount

		recalculateTokensAmount()

		payToken.delegate.selectedTokenDidChange()
		getToken.delegate.selectedTokenDidChange()
	}
}
