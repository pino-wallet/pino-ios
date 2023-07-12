//
//  SwapTokenViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation

class SwapTokenViewModel {
	// MARK: - Public Properties

	public var swapDelegate: SwapDelegate!

	public let maxTitle = "Max: "
	public let avgSign = "≈"
	public var amountUpdated: ((String) -> Void)!
	public var textFieldPlaceHolder = "0"
	public var isEditing = false
	public var selectedToken: AssetViewModel
	@Published
	public var tokenAmount = ""
	public var dollarAmount = ""
	public var decimalDollarAmount: Decimal?

	public var maxHoldAmount: String {
		selectedToken.amount
	}

	public var formattedAmount: String {
		if tokenAmount == "" {
			return .emptyString
		} else {
			return "\(avgSign) $\(dollarAmount)"
		}
	}

	public var formattedTokenAmount: String? {
		if tokenAmount == .emptyString {
			return nil
		} else {
			return "\(tokenAmount) \(selectedToken.symbol)"
		}
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		tokenAmount = amount
		if let decimalNumber = Decimal(string: amount), let price = Decimal(string: selectedToken.price.decimalString) {
			decimalDollarAmount = decimalNumber * price
			dollarAmount = decimalDollarAmount!.formattedAmount(type: .priceRule)
		} else {
			decimalDollarAmount = nil
			dollarAmount = "0"
		}
	}

	public func calculateTokenAmount(decimalDollarAmount: Decimal?) {
		self.decimalDollarAmount = decimalDollarAmount
		dollarAmount = decimalDollarAmount?.formattedAmount(type: .priceRule) ?? "0"
		tokenAmount = convertDollarAmountToTokenAmount(dollarAmount: decimalDollarAmount)
	}

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
			return .isZero
		} else {
			let decimalMaxAmount = Decimal(string: selectedToken.holdAmount.sevenDigitFormat)!
			let enteredAmount = Decimal(string: amount) ?? 0
			if enteredAmount > decimalMaxAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

	// MARK: - Private Methods

	private func convertDollarAmountToTokenAmount(dollarAmount: Decimal?) -> String {
		if let dollarAmount, let tokenPrice = Decimal(string: selectedToken.price.decimalString) {
			let tokenAmount = dollarAmount / tokenPrice
			return tokenAmount.formattedAmount(type: .sevenDigitsRule)
		} else {
			return .emptyString
		}
	}
}
