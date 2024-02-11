//
//  SwapTokenViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation
import Web3_Utility

class SwapTokenViewModel {
	// MARK: - Public Properties

	public var swapDelegate: SwapDelegate!

	public let maxTitle = "Max: "
	public let avgSign = "≈"
	public var amountUpdated: ((BigNumber) -> Void)!
	public var textFieldPlaceHolder = "0"
	public var isEditing = false
	@Published
	public var selectedToken: AssetViewModel
	@Published
	public var tokenAmount: BigNumber?
	public var dollarAmount: BigNumber?
	public var maxHoldAmount: BigNumber

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
		self.maxHoldAmount = selectedToken.holdAmount
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ enteredAmount: BigNumber?) {
		if let enteredAmount {
			tokenAmount = enteredAmount
            dollarAmount = enteredAmount * selectedToken.price
		} else {
			tokenAmount = nil
			dollarAmount = nil
		}
	}

	public func calculateTokenAmount(decimalDollarAmount: BigNumber?) {
		dollarAmount = decimalDollarAmount
		tokenAmount = convertDollarAmountToTokenAmount(dollarAmount: decimalDollarAmount)
	}

	public func setAmount(tokenAmount: BigNumber?, dollarAmount: BigNumber?) {
		self.dollarAmount = dollarAmount
		if let tokenAmount {
			self.tokenAmount = tokenAmount
		} else {
			self.tokenAmount = nil
		}
	}

	public func checkBalanceStatus(token: AssetViewModel) -> AmountStatus {
		if let amount = tokenAmount, !amount.isZero {
			if amount > token.holdAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		} else {
			return .isZero
		}
	}

	// MARK: - Private Methods

	private func convertDollarAmountToTokenAmount(dollarAmount: BigNumber?) -> BigNumber? {
		if let dollarAmount {
			let priceAmount = dollarAmount.number * 10.bigNumber.number
				.power(6 + selectedToken.decimal - dollarAmount.decimal)
			let price = selectedToken.price

			let tokenAmountDecimalValue = priceAmount.quotientAndRemainder(dividingBy: price.number)
			let tokenAmount = BigNumber(number: tokenAmountDecimalValue.quotient, decimal: selectedToken.decimal)
			return tokenAmount
		} else {
			return nil
		}
	}
}
