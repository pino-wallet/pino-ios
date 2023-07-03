//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/1/23.
//

import Foundation

class SwapViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Swap"
	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"

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

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
			return .isZero
		} else {
			let decimalMaxAmount = Decimal(string: payToken.selectedToken.holdAmount.formattedAmountOf(type: .hold))!
			let enteredAmount = Decimal(string: amount) ?? 0
			if enteredAmount > decimalMaxAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

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
