//
//  WithdrawAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

class WithdrawAmountViewModel {
	// MARK: - Public Properties

	public let pageTitleWithdrawText = "Withdraw"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let continueButtonTitle = "Withdraw"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

	public let userCollateralledTokenID: String
	public let borrowVM: BorrowViewModel
	public var userCollateralledTokenModel: UserBorrowingToken!

	public var selectedToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userCollateralledTokenModel.id }))!
	}

	public var tokenAmount: String = .emptyString
	public var dollarAmount: String = .emptyString
	// This is max of user collateralled amount
	public var maxWithdrawAmount: BigNumber {
		BigNumber(number: userCollateralledTokenModel.amount, decimal: selectedToken.decimal)
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var formattedMaxWithdrawAmount: String {
		maxWithdrawAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var maxWithdrawAmountInDollars: String {
		maxWithdrawAmount.priceFormat
	}

	#warning("this is mock")
	public var prevHealthScore: Double = 0
	public var newHealthScore: Double = 24

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel, userCollateralledTokenID: String) {
		self.userCollateralledTokenID = userCollateralledTokenID
		self.borrowVM = borrowVM

		setUserCollateralledToken()
	}

	// MARK: - Private Methods

	private func setUserCollateralledToken() {
		userCollateralledTokenModel = borrowVM.userBorrowingDetails?.collateralTokens
			.first(where: { $0.id == userCollateralledTokenID })
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
			if BigNumber(numberWithDecimal: tokenAmount) > maxWithdrawAmount {
				return .isNotEnough
			} else {
				return .isEnough
			}
		}
	}
}
