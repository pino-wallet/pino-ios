//
//  BorrowIncreaseAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

class BorrowIncreaseAmountViewModel {
	// MARK: - Public Properties

	public let pageTitleBorrowText = "Borrow"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Borrow"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

	public let selectedToken: AssetViewModel
	public let borrowVM: BorrowViewModel
	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	// here max amount is sum of user max free collateralled amount in tokens
    #warning("maybe we should refactor this section in future")
	public var maxHoldAmount: BigNumber {
		var totalFreeCollateralledInDollars = BigNumber(number: "0", decimal: selectedToken.decimal)
		for collateralledToken in borrowVM.userBorrowingDetails?.collateralTokens ?? [] {
			guard let foundTokenInManageAssetsList = GlobalVariables.shared.manageAssetsList?
				.first(where: { $0.id == collateralledToken.id }) else {
				return totalFreeCollateralledInDollars
			}
			let userCollateralledAmountIntoken = BigNumber(
				number: collateralledToken.amount,
				decimal: foundTokenInManageAssetsList.decimal
			)
			let freeCollateralledTokenAmount =
				(
					userCollateralledAmountIntoken * BigNumber(
						numberWithDecimal: borrowVM.calculatedHealthScore.description
					) /
						100.bigNumber
				)!
			let freeCollateralledTokenAmountInDollars = freeCollateralledTokenAmount * foundTokenInManageAssetsList
				.price
			totalFreeCollateralledInDollars = totalFreeCollateralledInDollars + freeCollateralledTokenAmountInDollars
		}
		return (totalFreeCollateralledInDollars / selectedToken.price)!
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.plainSevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var plainSevenDigitMaxHoldAmount: String {
		maxHoldAmount.plainSevenDigitFormat
	}

	public var maxHoldAmountInDollars: String {
		(maxHoldAmount * selectedToken.price).priceFormat
	}

	#warning("this values are mock")
	public var prevHealthScore: Double = 0
	public var newHealthScore: Double = 24

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, borrowVM: BorrowViewModel) {
		self.selectedToken = selectedToken
		self.borrowVM = borrowVM
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
