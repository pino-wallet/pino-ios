//
//  RepayAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

#warning("this values are static and mock")
class RepayAmountViewModel {
	// MARK: - Public Properties

	public let pageTitleRepayText = "Repay"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Repay"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

    public var prevHealthScore: Double = 0
    public var newHealthScore: Double = 24
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	public var maxHoldAmount: BigNumber = 100.bigNumber
	public var selectedToken = AssetViewModel(
		assetModel: BalanceAssetModel(
			id: "1",
			amount: "100000000000000000000",
			detail: Detail(
				id: "1",
				symbol: "LINK",
				name: "LINK",
				logo: "https://demo-cdn.pino.xyz/tokens/chainlink.png",
				decimals: 18,
				change24H: "230",
				changePercentage: "23",
				price: "6089213"
			),
			previousDayNetworth: "100"
		),
		isSelected: true
	)
	public let tokenSymbol = "LINK"

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
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
}
