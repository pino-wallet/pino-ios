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
			self.payToken.calculateAmount(amount)
			self.calculateTokenAmount(token: self.getToken, amount: self.payToken.decimalDollarAmount)
		}
		self.getToken.amountUpdated = { amount in
			self.getToken.calculateAmount(amount)
			self.calculateTokenAmount(token: self.payToken, amount: self.getToken.decimalDollarAmount)
		}
	}

	// MARK: - Private Methods

	private func updatePayToken(amount: String) {
		payToken.calculateAmount(amount)
		if payToken.isEditing {
			calculateTokenAmount(token: getToken, amount: payToken.decimalDollarAmount)
		}
	}

	private func updateGetToken(amount: String) {
		getToken.calculateAmount(amount)
		if getToken.isEditing {
			calculateTokenAmount(token: payToken, amount: getToken.decimalDollarAmount)
		}
	}

	private func calculateTokenAmount(token: SwapTokenViewModel, amount: Decimal?) {
		if let amount, let getTokenPrice = Decimal(string: token.selectedToken.price.decimalString) {
			let tokenDecimalAmount = amount / getTokenPrice
			token.calculateAmount(tokenDecimalAmount.formattedAmount(type: .tokenValue))
		} else {
			token.calculateAmount("")
		}
		token.swapAmountCalculated(token.tokenAmount)
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

	public func changeSelectedPayToken(to newToken: AssetViewModel) {
		payToken.selectedToken = newToken
		if payToken.isEditing {
			updatePayToken(amount: payToken.tokenAmount)
		} else {
			updateGetToken(amount: getToken.tokenAmount)
		}
		payToken.selectedTokenChanged()
	}

	public func changeSelectedGetToken(to newToken: AssetViewModel) {
		getToken.selectedToken = newToken
		if getToken.isEditing {
			updateGetToken(amount: getToken.tokenAmount)
		} else {
			updatePayToken(amount: payToken.tokenAmount)
		}
		getToken.selectedTokenChanged()
	}

	public func switchTokens() {
		let selectedPayToken = payToken.selectedToken
		payToken.selectedToken = getToken.selectedToken
		getToken.selectedToken = selectedPayToken

		let payTokenAmount = payToken.tokenAmount
		let getTokenAmount = getToken.tokenAmount

		payToken.calculateAmount(getTokenAmount)
		getToken.calculateAmount(payTokenAmount)

		payToken.swapAmountCalculated(payToken.tokenAmount)
		getToken.swapAmountCalculated(getToken.tokenAmount)

		payToken.selectedTokenChanged()
		getToken.selectedTokenChanged()
	}
}
