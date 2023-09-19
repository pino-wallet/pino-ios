//
//  BorrowIncreaseAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

class BorrowIncreaseAmountViewModel {
	// MARK: - Public Properties

	public let pageTitleBorrowText = "Borrow"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Borrow"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

	public let selectedToken: AssetViewModel
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	// here max amount is user max hold amount of selected token
	public var maxHoldAmount: BigNumber {
		selectedToken.holdAmount
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var sevenDigitMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat
	}

	public var maxHoldAmountInDollars: String {
		selectedToken.holdAmountInDollor.priceFormat
	}

	#warning("this values are mock")
	public var prevHealthScore: Double = 0
	public var newHealthScore: Double = 24

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if amount != .emptyString {
			let decimalBigNum = BigNumber(numberWithDecimal: amount)
			let price = selectedToken.price

			let amountInDollarDecimalValue = BigNumber(
				number: decimalBigNum.number * price.number,
				decimal: decimalBigNum.decimal + 6
			)
			dollarAmount = amountInDollarDecimalValue.priceFormat
		} else {
			dollarAmount = .emptyString
		}
		tokenAmount = amount
	}

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if BigNumber(numberWithDecimal: amount).isZero {
			return .isZero
		} else {
			if BigNumber(numberWithDecimal: tokenAmount) > maxHoldAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}
}
