//
//  InvestDepositViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/23/23.
//

import BigInt
import Foundation

class InvestDepositViewModel {
	// MARK: - Public Properties

	public let maxTitle = "Available: "
	public let continueButtonTitle = "Deposit"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public var textFieldPlaceHolder = "0"
	public var estimatedReturnTitle = "Yearly estimated return"
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var maxHoldAmount: BigNumber!
	public var selectedToken: AssetViewModel!

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var pageTitle: String {
		"Invest in \(selectedToken.symbol)"
	}

	@Published
	public var yearlyEstimatedReturn: String?

	// MARK: - Initializers

	init(selectedAsset: InvestableAssetViewModel) {
		getToken(investableAsset: selectedAsset)
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if amount != .emptyString {
			let decimalBigNum = BigNumber(numberWithDecimal: amount)
			let price = selectedToken.price

			let amountInDollarDecimalValue = BigNumber(
				number: decimalBigNum.number * price.number,
				decimal: decimalBigNum.decimal + 6
			)
			dollarAmount = amountInDollarDecimalValue.priceFormat
		} else {
			dollarAmount = .emptyString
		}
		tokenAmount = amount
		getYearlyEstimatedReturn(amount: amount)
	}

	public func checkBalanceStatus(amount: String) -> AmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if BigNumber(numberWithDecimal: amount).isZero {
			return .isZero
		} else {
			if BigNumber(numberWithDecimal: tokenAmount) > maxHoldAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}

	// MARK: - Private Methods

	private func getToken(investableAsset: InvestableAssetViewModel) {
		let tokensList = GlobalVariables.shared.manageAssetsList!
		selectedToken = tokensList.first(where: { $0.symbol == investableAsset.assetName })!
		maxHoldAmount = selectedToken.holdAmount
	}

	private func getYearlyEstimatedReturn(amount: String) {
		if amount == .emptyString {
			yearlyEstimatedReturn = nil
		} else {
			yearlyEstimatedReturn = amount.tokenFormatting(token: selectedToken.symbol)
		}
	}
}
