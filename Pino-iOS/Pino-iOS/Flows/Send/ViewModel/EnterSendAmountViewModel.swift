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

	public var tokenAmount = "0.0"

	public var dollarAmount = "0.0"

	public var formattedAmount: String {
		if isDollarEnabled {
			return "≈ \(tokenAmount) \(selectedToken.symbol)"
		} else {
			return "≈ $\(dollarAmount)"
		}
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false) {
		self.selectedToken = selectedToken
		self.isDollarEnabled = isDollarEnabled
	}

	// MARK: - Public Methods

	public func calculateAmount(_ amount: String) {
		if isDollarEnabled {
			convertDollarAmountToTokenValue(amount: amount)
		} else {
			convertEnteredAmountToDollar(amount: amount)
		}
	}

	public func checkIfBalanceIsEnough(amount: String, isEnough: (Bool) -> Void) {
		let maxAmmount = Decimal(string: maxAmount)!
		let enteredAmmount = Decimal(string: tokenAmount)!
		if enteredAmmount > maxAmmount {
			isEnough(false)
		} else {
			isEnough(true)
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
