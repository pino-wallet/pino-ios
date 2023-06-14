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

	public var enteredAmount = "0.0"

	public var formattedAmount: String {
		if isDollarEnabled {
			return "\(enteredAmount) \(selectedToken.symbol)"
		} else {
			return "$\(enteredAmount)"
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

	#warning("Calculations are NOT correct and must be changed in the next branch")

	private func convertEnteredAmountToDollar(amount: String) {
		let enteredAmountNumber = BigNumber(number: amount, decimal: 1) * selectedToken.price
		enteredAmount = enteredAmountNumber.formattedAmountOf(type: .price)
	}

	private func convertDollarAmountToTokenValue(amount: String) {
		let enteredAmountNumber = BigNumber(number: amount, decimal: 1) / selectedToken.price
		enteredAmount = enteredAmountNumber?.formattedAmountOf(type: .price) ?? "0.0"
	}
}
