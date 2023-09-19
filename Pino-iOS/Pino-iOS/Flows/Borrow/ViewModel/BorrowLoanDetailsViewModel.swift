//
//  BorrowDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

struct BorrowLoanDetailsViewModel {
	// MARK: - Public Properties

	public let dismissIconName = "dissmiss"
	public let apyTitle = "APY"
	public let borrowedAmountTitle = "Borrowed amount"
	public let accuredFeeTitle = "Accured fee"
	public let totalDebtTitle = "Total debt"
	public let increaseLoanTitle = "Increase loan"
	public let repayTitle = "Repay"
	public let userBorrowedTokenModel: UserBorrowingToken

	public var pageTitle: String {
		"\(foundTokenInManageAssetTokens.symbol) loan details"
	}

	public var tokenIcon: URL {
		foundTokenInManageAssetTokens.image
	}

	public var tokenBorrowAmountAndSymbol: String {
		borrowedAmountBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	#warning("this is mock")
	public let apy = "%3"
	public var borrowedAmount: String {
		borrowedAmountBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var accuredFee: String {
		let accuredFee = totalDebtBigNumber - borrowedAmountBigNumber
		return accuredFee.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	public var totalDebt: String {
		totalDebtBigNumber.sevenDigitFormat.tokenFormatting(token: foundTokenInManageAssetTokens.symbol)
	}

	// MARK: - Private Properties

	private var totalDebtBigNumber: BigNumber {
		BigNumber(number: userBorrowedTokenModel.totalDebt!, decimal: foundTokenInManageAssetTokens.decimal)
	}

	private var borrowedAmountBigNumber: BigNumber {
		BigNumber(number: userBorrowedTokenModel.amount, decimal: foundTokenInManageAssetTokens.decimal)
	}

	private var foundTokenInManageAssetTokens: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == userBorrowedTokenModel.id }))!
	}

	// MARK: - Initializers

	init(userBorrowedTokenModel: UserBorrowingToken) {
		self.userBorrowedTokenModel = userBorrowedTokenModel
	}
}
