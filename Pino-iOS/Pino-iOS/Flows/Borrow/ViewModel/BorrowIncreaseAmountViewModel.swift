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
	public var tokenAmount: String = "0"
	public var dollarAmount: String = .emptyString
	// here max amount is sum of user max free collateralled amount in tokens
	#warning("maybe we should refactor this section in future")
	public var maxHoldAmount: BigNumber {
		var totalFreeCollateralledInDollars = BigNumber(number: "0", decimal: selectedToken.decimal)
		for collateralledToken in borrowVM.userBorrowingDetails?.collateralTokens ?? [] {
			guard let foundCollateralledToken = GlobalVariables.shared.manageAssetsList?
				.first(where: { $0.id == collateralledToken.id }) else {
				return totalFreeCollateralledInDollars
			}
			let userCollateralledAmountIntoken = BigNumber(
				number: collateralledToken.amount,
				decimal: foundCollateralledToken.decimal
			)
			let freeCollateralledTokenAmount =
				(
					userCollateralledAmountIntoken * BigNumber(
						numberWithDecimal: borrowVM.calculatedHealthScore.description
					) /
						100.bigNumber
				)!
			#warning("maybe we should change this section later")
			guard let tokenLiquidationThreshold = borrowVM.collateralizableTokens?
				.first(where: { $0.tokenID == collateralledToken.id })?.liquidationThreshold else {
				return totalFreeCollateralledInDollars
			}
			let onePercentOfFreeCollateralledAmount = freeCollateralledTokenAmount / 100.bigNumber
			let borrowableTokenAmount = onePercentOfFreeCollateralledAmount! * (tokenLiquidationThreshold / 100)
				.bigNumber
			let freeCollateralledTokenAmountInDollars = borrowableTokenAmount * foundCollateralledToken
				.price
			totalFreeCollateralledInDollars = totalFreeCollateralledInDollars + freeCollateralledTokenAmountInDollars
		}
		return totalFreeCollateralledInDollars / selectedToken.price ?? 0.bigNumber
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var plainSevenDigitMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat
	}

	public var maxHoldAmountInDollars: String {
		(maxHoldAmount * selectedToken.price).priceFormat
	}

	public var prevHealthScore: BigNumber {
		calculateCurrentHealthScore()
	}

	public var newHealthScore: BigNumber = 0.bigNumber

	// MARK: - Private Properties

	private let borrowingHelper = BorrowingHelper()

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, borrowVM: BorrowViewModel) {
		self.selectedToken = selectedToken
		self.borrowVM = borrowVM
	}

	// MARK: - Private Methods

	private func calculateCurrentHealthScore() -> BigNumber {
		borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: borrowVM.totalBorrowAmountInDollars,
			totalBorrowableAmountForHealthScore: borrowVM.totalCollateralAmountsInDollar
				.totalBorrowableAmountInDollars
		)
	}

	private func calculateNewHealthScore(dollarAmount: BigNumber) -> BigNumber {
		let totalBorrowedAmount = borrowVM.totalBorrowAmountInDollars + dollarAmount
		return borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: totalBorrowedAmount,
			totalBorrowableAmountForHealthScore: borrowVM.totalCollateralAmountsInDollar
				.totalBorrowableAmountInDollars
		)
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
			newHealthScore = calculateNewHealthScore(dollarAmount: amountInDollarDecimalValue)
			dollarAmount = amountInDollarDecimalValue.priceFormat
		} else {
			newHealthScore = calculateCurrentHealthScore()
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
