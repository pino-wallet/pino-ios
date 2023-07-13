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
	public var decimalDollarAmount: BigNumber?

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
        let price = selectedToken.price
        decimalDollarAmount = BigNumber(numberWithDecimal: amount) * price
        dollarAmount = decimalDollarAmount!.priceFormat
        
	}

	public func calculateTokenAmount(decimalDollarAmount: BigNumber?) {
		self.decimalDollarAmount = decimalDollarAmount
		dollarAmount = decimalDollarAmount?.priceFormat ?? "0"
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

	private func convertDollarAmountToTokenAmount(dollarAmount: BigNumber?) -> String {
		if let dollarAmount {
            let tokenPrice =  selectedToken.price
			let tokenAmount = dollarAmount / tokenPrice
            return tokenAmount!.sevenDigitFormat
		} else {
			return .emptyString
		}
	}
}
