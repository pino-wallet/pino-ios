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
	}

	// MARK: - Public Methods

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
			return .isZero
		} else {
			let decimalMaxAmount = Decimal(string: payToken.selectedToken.holdAmount.formattedAmountOf(type: .hold))!
			let enteredAmount = Decimal(string: amount)!
			if enteredAmount > decimalMaxAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

	public func switchTokens() {
		let selectedPayToken = payToken.selectedToken
		payToken.selectedToken = getToken.selectedToken
		getToken.selectedToken = selectedPayToken
	}
}
