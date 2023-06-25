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

	public var maxAmount: String {
		selectedToken.amount
	}

	public var ethPrice: BigNumber!
	public var tokenAmount = "0.0"
	public var dollarAmount = "0.0"

	public var formattedAmount: String {
		if isDollarEnabled {
			return "≈ \(tokenAmount) \(selectedToken.symbol)"
		} else {
			return "≈ $\(dollarAmount)"
		}
	}

	public enum AmountStatus {
		case isNotEnough
		case isEnough
		case isZero
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
		if let decimalAmount = Decimal(string: amount), decimalAmount.isZero {
			amountStatus(.isZero)
		} else {
			let decimalMaxAmount = Decimal(string: maxAmount)!
			calculateAmount(amount)
			let enteredAmmount = Decimal(string: tokenAmount)!
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
		dollarAmount = formattedAmount(of: decimalNumber * price)
		tokenAmount = amount
	}

	private func convertDollarAmountToTokenValue(amount: String) {
		guard let decimalNumber = Decimal(string: amount),
		      let price = Decimal(string: selectedToken.price.decimalString) else { return }
		tokenAmount = formattedAmount(of: decimalNumber / price)
		dollarAmount = amount
	}

	private func formattedAmount(of decimalNumber: Decimal) -> String {
		var decimalNumber = decimalNumber
		var roundedDecimal: Decimal = 0
		NSDecimalRound(&roundedDecimal, &decimalNumber, 12, .up)
		return roundedDecimal.description
	}
}
