//
//  EnterSendAmountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import BigInt
import Foundation

class EnterSendAmountViewModel {
	// MARK: - Public Properties

	public var isDollarEnabled: Bool
	public let maxTitle = "Max: "
	public let dollarIcon = "dollar_icon"
	public let continueButtonTitle = "Next"
	public let dollarSign = "$"
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

	public var maxHoldAmount: BigNumber!
	public var maxAmountInDollar: BigNumber!
	public var tokenAmount: BigNumber?
	public var dollarAmount: BigNumber?

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var formattedMaxAmountInDollar: String {
		maxAmountInDollar.priceFormat
	}

	public var formattedAmount: String {
		if isDollarEnabled {
			return tokenAmount == nil ? "" :
				"\(tokenAmount!.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol))"
		} else {
			return dollarAmount == nil ? "" : dollarAmount!.priceFormat
		}
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false) {
		self.selectedToken = selectedToken
		self.isDollarEnabled = isDollarEnabled
		updateTokenMaxAmount()
	}

	// MARK: - Public Methods

	public func calculateAmount(_ amount: String) {
		guard let bignumAmount = BigNumber(numberWithDecimal: amount) else { return }
		if isDollarEnabled {
			convertDollarAmountToTokenValue(amount: bignumAmount)
		} else {
			convertEnteredAmountToDollar(amount: bignumAmount)
		}
	}

	public func checkIfBalanceIsEnough(amount: String, amountStatus: (AmountStatus) -> Void) {
		guard let amountBigNumber = BigNumber(numberWithDecimal: amount) else {
			amountStatus(.isZero)
			return
		}
		if amountBigNumber.isZero ||
			amountBigNumber <= .minAcceptableAmount ||
			amountBigNumber.decimal > selectedToken.decimal {
			amountStatus(.isZero)
			return
		}
		var decimalMaxAmount: BigNumber
		var enteredAmmount: BigNumber
		if isDollarEnabled {
			decimalMaxAmount = maxAmountInDollar
			enteredAmmount = dollarAmount!
		} else {
			decimalMaxAmount = maxHoldAmount
			enteredAmmount = tokenAmount!
		}
		if enteredAmmount > decimalMaxAmount {
			amountStatus(.isNotEnough)
		} else {
			amountStatus(.isEnough)
		}
	}

	public func updateEthMaxAmount() {
		let gasInfo = Web3Core.shared.calculateEthGasFee()
		let estimatedAmount = selectedToken.holdAmount - gasInfo.fee!
		if estimatedAmount.number.sign == .minus {
			maxHoldAmount = 0.bigNumber
		} else {
			maxHoldAmount = estimatedAmount
		}

		let estimatedAmountInDollar = selectedToken.holdAmountInDollor - gasInfo.feeInDollar!
		if estimatedAmountInDollar.number.sign == .minus {
			maxAmountInDollar = 0.bigNumber
		} else {
			maxAmountInDollar = estimatedAmountInDollar
		}
	}

	// MARK: - Private Methods

	private func updateTokenMaxAmount() {
		if selectedToken.isEth {
			updateEthMaxAmount()
		} else {
			maxHoldAmount = selectedToken.holdAmount
			maxAmountInDollar = selectedToken.holdAmountInDollor
		}
	}

	private func convertEnteredAmountToDollar(amount: BigNumber) {
		if amount != 0.bigNumber {
			let price = selectedToken.price

			let amountInDollarDecimalValue = BigNumber(
				number: amount.number * price.number,
				decimal: amount.decimal + 6
			)
			dollarAmount = amountInDollarDecimalValue
		} else {
			dollarAmount = 0.bigNumber
		}
		tokenAmount = amount
	}

	private func convertDollarAmountToTokenValue(amount: BigNumber) {
		if amount != 0.bigNumber {
			let priceAmount = amount.number * BigInt(10).power(6 + selectedToken.decimal - amount.decimal)
			let price = selectedToken.price

			let tokenAmountDecimalValue = priceAmount.quotientAndRemainder(dividingBy: price.number)
			tokenAmount = BigNumber(number: tokenAmountDecimalValue.quotient, decimal: selectedToken.decimal)
		} else {
			tokenAmount = 0.bigNumber
		}
		dollarAmount = amount
	}
}
