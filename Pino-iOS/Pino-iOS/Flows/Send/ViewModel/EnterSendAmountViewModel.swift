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
	public var textFieldPlaceHolder = "0"

	public var selectedToken: AssetViewModel {
		didSet {
			updateTokenMaxAmount()
			if let selectedTokenChanged {
				selectedTokenChanged()
			}
		}
	}

	public var maxHoldAmount = "0"
	public var maxAmountInDollar = "0"

	public var formattedMaxHoldAmount: String {
		"\(maxHoldAmount) \(selectedToken.symbol)"
	}

	public var formattedMaxAmountInDollar: String {
		"$ \(maxAmountInDollar)"
	}

	public var ethToken: AssetViewModel!
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

	init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false, ethToken: AssetViewModel) {
		self.selectedToken = selectedToken
		self.isDollarEnabled = isDollarEnabled
		self.ethToken = ethToken
		updateTokenMaxAmount()
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
				decimalMaxAmount = Decimal(string: maxAmountInDollar)!
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

	public func updateEthMaxAmount(
		gasFee: BigNumber = GlobalVariables.shared.ethGasFee.fee,
		gasFeeInDollar: BigNumber = GlobalVariables.shared.ethGasFee.feeInDollar
	) {
		let estimatedAmount = selectedToken.holdAmount - gasFee
		maxHoldAmount = estimatedAmount.formattedAmountOf(type: .sevenDigitsRule)

		let estimatedAmountInDollar = selectedToken.holdAmountInDollor - gasFeeInDollar
		maxAmountInDollar = estimatedAmountInDollar.formattedAmountOf(type: .priceRule)
	}

	// MARK: - Private Methods

	private func updateTokenMaxAmount() {
		if selectedToken.isEth {
			updateEthMaxAmount()
		} else {
			maxHoldAmount = selectedToken.holdAmount.formattedAmountOf(type: .sevenDigitsRule)
			maxAmountInDollar = selectedToken.formattedHoldAmount
		}
	}

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
		tokenAmount = selectedToken.holdAmount.formattedAmountOf(type: .sevenDigitsRule)
		dollarAmount = amount
	}
}
