//
//  EnterSendAmountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import Foundation

class EnterSendAmountViewModel {
	// MARK: - Public Properties

	public var isDollarEnabled: Bool
	public let maxTitle = "Max: "
	public let dollarIcon = "dollar_icon"
	public let continueButtonTitle = "Next"
	public let dollarSign = "$"
	public let avgSign = "≈"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public var selectedTokenChanged: (() -> Void)?
	public var textFieldPlaceHolder = "0.0"

	public var selectedToken: AssetViewModel {
		didSet {
			if let selectedTokenChanged {
				selectedTokenChanged()
			}
		}
	}

	public var maxHoldAmount: String {
		selectedToken.amount
	}

	public var maxAmountInDollar: String {
		"$ \(selectedToken.formattedHoldAmount)"
	}

	public var ethPrice: BigNumber!
	public var tokenAmount = "0.0"
	public var dollarAmount = "0.0"

	public var formattedAmount: String {
		if isDollarEnabled {
			return "\(avgSign) \(tokenAmount) \(selectedToken.symbol)"
		} else {
			return "\(avgSign) $\(dollarAmount)"
		}
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false, ethPrice: BigNumber) {
		self.selectedToken = selectedToken
		self.isDollarEnabled = isDollarEnabled
		self.ethPrice = ethPrice
	}

	// MARK: - Public Methods

	public func calculateAmount(_ amount: String) {
		if isDollarEnabled {
			convertDollarAmountToTokenValue(amount: amount)
		} else {
			convertEnteredAmountToDollar(amount: amount)
		}
	}

	public func checkIfBalanceIsEnough(amount: String, amountStatus: (AmountStatus) -> Void) {
		calculateAmount(amount)
		if amount == .emptyString {
			amountStatus(.isZero)
		} else if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
			amountStatus(.isZero)
		} else {
			var decimalMaxAmount: Decimal
			var enteredAmmount: Decimal
			if isDollarEnabled {
				decimalMaxAmount = Decimal(string: selectedToken.formattedHoldAmount)!
				enteredAmmount = Decimal(string: dollarAmount)!
			} else {
				decimalMaxAmount = Decimal(string: maxHoldAmount)!
				enteredAmmount = Decimal(string: tokenAmount)!
			}
			if enteredAmmount > decimalMaxAmount {
				amountStatus(.isNotEnough)
			} else {
				amountStatus(.isEnough)
			}
		}
	}

	// MARK: - Private Methods

	private func convertEnteredAmountToDollar(amount: String) {
		guard let decimalNumber = Decimal(string: amount),
		      let price = Decimal(string: selectedToken.price.decimalString) else { return }
		let amountInDollarDecimalValue = decimalNumber * price
		dollarAmount = amountInDollarDecimalValue.formattedAmount(type: .dollarValue)
		tokenAmount = amount
	}

	private func convertDollarAmountToTokenValue(amount: String) {
		guard let decimalNumber = Decimal(string: amount),
		      let price = Decimal(string: selectedToken.price.decimalString) else { return }
		let tokenAmountDecimalValue = decimalNumber / price
		tokenAmount = tokenAmountDecimalValue.formattedAmount(type: .tokenValue)
		dollarAmount = amount
	}
}
