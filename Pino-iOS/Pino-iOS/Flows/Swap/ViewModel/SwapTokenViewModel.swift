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
	@Published
	public var selectedToken: AssetViewModel
	@Published
	public var tokenAmount: String?
	public var dollarAmount: String?
	public var decimalDollarAmount: BigNumber?
	public var maxHoldAmount: String

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
		self.maxHoldAmount = selectedToken.amount
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String?) {
		if let amount {
			calculateDollarAmount(enteredAmount: amount)
		} else {
			calculateDollarAmount(enteredAmount: tokenAmount)
		}
	}

	public func calculateTokenAmount(decimalDollarAmount: BigNumber?) {
		self.decimalDollarAmount = decimalDollarAmount
		dollarAmount = decimalDollarAmount?.priceFormat
		tokenAmount = convertDollarAmountToTokenAmount(dollarAmount: decimalDollarAmount)
	}

	public func setAmount(tokenAmount: String?, dollarAmount: String?) {
		self.dollarAmount = dollarAmount
		if let tokenAmount {
			self.tokenAmount = BigNumber(number: tokenAmount, decimal: selectedToken.decimal).decimalString
		} else {
			self.tokenAmount = nil
		}
	}

	public func checkBalanceStatus(token: AssetViewModel) -> AmountStatus {
		if let amount = tokenAmount, !BigNumber(numberWithDecimal: amount).isZero {
			let maxAmount = token.holdAmount
			let enteredAmount = BigNumber(numberWithDecimal: amount)
			if enteredAmount > maxAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		} else {
			return .isZero
		}
	}

	// MARK: - Private Methods

	private func calculateDollarAmount(enteredAmount: String?) {
		if let enteredAmount, enteredAmount != .emptyString {
			tokenAmount = enteredAmount
			decimalDollarAmount = BigNumber(numberWithDecimal: enteredAmount) * selectedToken.price
			dollarAmount = decimalDollarAmount?.priceFormat
		} else {
			tokenAmount = nil
			decimalDollarAmount = nil
			dollarAmount = nil
		}
	}

	private func convertDollarAmountToTokenAmount(dollarAmount: BigNumber?) -> String? {
		if let dollarAmount {
			let priceAmount = dollarAmount.number * 10.bigNumber.number
				.power(6 + selectedToken.decimal - dollarAmount.decimal)
			let price = selectedToken.price

			let tokenAmountDecimalValue = priceAmount.quotientAndRemainder(dividingBy: price.number)
			let tokenAmount = BigNumber(number: tokenAmountDecimalValue.quotient, decimal: selectedToken.decimal)
				.sevenDigitFormat
			return tokenAmount
		} else {
			return nil
		}
	}
}
