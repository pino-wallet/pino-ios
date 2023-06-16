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

    private func convertEnteredAmountToDollar(amount: String) {
		let enteredAmountNumber = BigNumber(decimalNumber: amount) * selectedToken.price
		enteredAmount = enteredAmountNumber.formattedAmountOf(type: .price)
	}

	private func convertDollarAmountToTokenValue(amount: String) {
		guard let decimalNumber = Decimal(string: amount),
        let price = Decimal(string: selectedToken.price.decimalString) else { return }
		var enteredAmountNumber = decimalNumber / price
        var roundedDecimal: Decimal = 0
        NSDecimalRound(&roundedDecimal, &enteredAmountNumber, 12, .up)
        enteredAmount = "≈ \(roundedDecimal.description)"
	}
    
    public func checkIfBalanceIsEnough(amount: String, isEnough: (Bool)->Void) {
        let maxAmmount = Decimal(string: maxAmount)!
        let enteredAmmount = Decimal(string: amount)!
        if enteredAmmount > maxAmmount {
            isEnough(false)
        }else {
            isEnough(true)
        }
    }
    
}
