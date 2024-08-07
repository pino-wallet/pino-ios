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
	public var amountUpdated: ((BigNumber?) -> Void)!
	public var textFieldPlaceHolder = "0"
	public var isEditing = false
	@Published
	public var selectedToken: AssetViewModel
	@Published
	public var tokenAmount: BigNumber?
	public var dollarAmount: BigNumber?
	public var fullAmount: BigNumber? {
		guard let tokenAmount else { return nil }
		let bigIntFormat = Utilities.parseToBigUInt(tokenAmount.decimalString, decimals: selectedToken.decimal)
		if let bigIntFormat {
			return .init(unSignedNumber: bigIntFormat, decimal: selectedToken.decimal)
		} else {
			return nil
		}
	}

	public var selectedTokenMaxAmount: BigNumber {
		SwapGasLimitsManager.getMaxAmount(selectedToken: selectedToken)
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ enteredAmount: BigNumber?) {
		tokenAmount = enteredAmount

		guard selectedToken.isVerified else {
			dollarAmount = nil
			return
		}

		if let enteredAmount {
			dollarAmount = enteredAmount * selectedToken.price
		} else {
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
		let maxAmount = SwapGasLimitsManager.getMaxAmount(selectedToken: selectedToken)
		if let amount = tokenAmount, !amount.isZero {
			if amount > maxAmount {
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
				.power(Web3Core.Constants.pricePercision + selectedToken.decimal - dollarAmount.decimal)
			let price = selectedToken.price

			let tokenAmountDecimalValue = priceAmount.quotientAndRemainder(dividingBy: price.number)
			let tokenAmount = BigNumber(number: tokenAmountDecimalValue.quotient, decimal: selectedToken.decimal)
			return tokenAmount
		} else {
			return nil
		}
	}
}
