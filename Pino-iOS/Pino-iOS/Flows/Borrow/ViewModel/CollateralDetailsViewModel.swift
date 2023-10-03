//
//  LoanDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/21/23.
//

import Foundation

struct CollateralDetailsViewModel {
	// MARK: - Public Properties

	public let freeTitle = "Free"
	public let involvedTitle = "Involved"
	public let totalCollateralTitle = "Total collateral"
	public let increaseLoanTitle = "Increase collateral"
	public let withdrawTitle = "Withdraw"
	public let dismissIconName = "dissmiss"
	public let collateralledTokenID: String
	public let borrowVM: BorrowViewModel
	public var collateralledTokenModel: UserBorrowingToken!

	public var pageTitle: String {
		"\(foundCollateralledToken.symbol) collateral details"
	}

	public var tokenCollateralAmountAndSymbol: String {
		userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	public var totalTokenAmountInDollar: String {
		let userAmountInDollars = userAmountInToken * foundCollateralledToken.price
		return userAmountInDollars.priceFormat
	}

	public var tokenIcon: URL {
		foundCollateralledToken.image
	}

	public var totalCollateral: String {
		userAmountInToken.sevenDigitFormat.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	public var foundCollateralledToken: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == collateralledTokenModel.id }))!
	}

	public var formattedInvolvedAmountInToken: String {
		(userAmountInToken - userFreeAmountInToken).sevenDigitFormat
			.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	public var freeAmountInToken: String {
		userFreeAmountInToken.sevenDigitFormat.tokenFormatting(token: foundCollateralledToken.symbol)
	}

	// MARK: - Private Properties

    // to calculate free amount of total collateralled amount of user, we should use this pattern: (totalCollateralledAmount * healthScore) / 100
    // make sure doing this with bignumbers
	private var userFreeAmountInToken: BigNumber {
		let bigNumberHealthScore = BigNumber(numberWithDecimal: borrowVM.calculatedHealthScore.description)
		return (((userAmountInToken * bigNumberHealthScore) / 100.bigNumber)!)
	}

	private var userAmountInToken: BigNumber {
		BigNumber(number: collateralledTokenModel.amount, decimal: foundCollateralledToken.decimal)
	}

	// MARK: - Initializers

	init(borrowVM: BorrowViewModel, collateralledTokenID: String) {
		self.collateralledTokenID = collateralledTokenID
		self.borrowVM = borrowVM

		setCollateraledToken()
	}

	// MARK: - Private Methods

	private mutating func setCollateraledToken() {
		collateralledTokenModel = borrowVM.userBorrowingDetails?.collateralTokens
			.first(where: { $0.id == collateralledTokenID })
	}
}
