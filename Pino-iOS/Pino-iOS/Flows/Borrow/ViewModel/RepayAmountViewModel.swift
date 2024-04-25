//
//  RepayAmountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/30/23.
//

import Foundation

class RepayAmountViewModel {
	// MARK: - Public Properties

	public enum RepayAmountStatus {
		case isNotEnough
		case isEnough
		case isZero
		case amountExceedsDebt
	}

	public let pageTitleRepayText = "Repay"
	public let insufficientAmountButtonTitle = "Insufficient amount"
	public let amountExceedsDebtButtonTitle = "Amount exceeds debt"
	public let continueButtonTitle = "Repay"
	public let maxTitle = "Max: "
	public var textFieldPlaceHolder = "0"

	public let userBorrowedTokenID: String
	public let borrowVM: BorrowViewModel
	public var selectedUserBorrowingToken: UserBorrowingToken!

	public var tokenAmount = "0"
	public var dollarAmount: String = .emptyString
	// check if user have more than his debt, use his debt for max amount to repay, otherwise use user amount in token to
	// repay the debt
	public var maxHoldAmount: BigNumber {
		if selectedToken.holdAmount >= selectedTokenTotalDebt {
			return selectedTokenTotalDebt
		} else {
			return selectedToken.holdAmount
		}
	}

	public var tokenSymbol: String {
		selectedToken.symbol
	}

	public var selectedToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == selectedUserBorrowingToken.id }))!
	}

	public var formattedMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat.tokenFormatting(token: selectedToken.symbol)
	}

	public var maxHoldAmountInDollars: String {
		maxHoldAmount.priceFormat(of: selectedToken.assetType, withRule: .standard)
	}

	public var tokenImage: URL {
		selectedToken.image
	}

	public var plainSevenDigitMaxHoldAmount: String {
		maxHoldAmount.sevenDigitFormat
	}

	public var prevHealthScore: BigNumber {
		calculateCurrentHealthScore()
	}

	public var newHealthScore: BigNumber = 0.bigNumber

	// MARK: - Private Properties

	private let borrowingHelper = BorrowingHelper()
	public var selectedTokenTotalDebt: BigNumber {
		BigNumber(number: selectedUserBorrowingToken.totalDebt!, decimal: selectedToken.decimal)
	}

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel, userBorrowedTokenID: String) {
		self.borrowVM = borrowVM
		self.userBorrowedTokenID = userBorrowedTokenID

		setUserBorrowedToken()
	}

	// MARK: - Private Methods

	private func setUserBorrowedToken() {
		selectedUserBorrowingToken = borrowVM.userBorrowingDetails?.borrowTokens
			.first(where: { $0.id == userBorrowedTokenID })
	}

	private func calculateCurrentHealthScore() -> BigNumber {
		borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: borrowVM.totalBorrowAmountInDollars,
			totalBorrowableAmountForHealthScore: borrowVM.totalCollateralAmountsInDollar
				.totalBorrowableAmountInDollars
		)
	}

	private func calculateNewHealthScore(dollarAmount: BigNumber) -> BigNumber {
		let totalBorrowedAmount = borrowVM.totalBorrowAmountInDollars - dollarAmount
		return borrowingHelper.calculateHealthScore(
			totalBorrowedAmount: totalBorrowedAmount,
			totalBorrowableAmountForHealthScore: borrowVM.totalCollateralAmountsInDollar
				.totalBorrowableAmountInDollars
		)
	}

	// MARK: - Public Methods

	public func calculateDollarAmount(_ amount: String) {
		if let decimalBigNum = BigNumber(numberWithDecimal: amount) {
			let amountInDollarDecimalValue = decimalBigNum * selectedToken.price
			newHealthScore = calculateNewHealthScore(dollarAmount: amountInDollarDecimalValue)
			dollarAmount = amountInDollarDecimalValue.priceFormat(of: selectedToken.assetType, withRule: .standard)
		} else {
			newHealthScore = calculateCurrentHealthScore()
			dollarAmount = .emptyString
		}
		tokenAmount = amount
	}

	public func checkBalanceStatus(amount: String) -> RepayAmountStatus {
		if amount == .emptyString {
			return .isZero
		} else if let amountBigNumber = BigNumber(numberWithDecimal: amount), amountBigNumber.isZero {
			return .isZero
		} else if let amountBigNumber = BigNumber(numberWithDecimal: tokenAmount) {
			if amountBigNumber > selectedToken.holdAmount {
				return .isNotEnough
			} else if amountBigNumber > selectedTokenTotalDebt {
				return .amountExceedsDebt
			} else {
				return .isEnough
			}
		} else {
			return .isNotEnough
		}
	}
}
