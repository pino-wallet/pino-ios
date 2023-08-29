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
	#warning("this is mock title")
	public let pageTitle = "LINK loan details"

	public let apyTitle = "APY"
	public let borrowedAmountTitle = "Borrowed amount"
	public let accuredFeeTitle = "Accured fee"
	public let totalDebtTitle = "Total debt"
	public let increaseLoanTitle = "Increase loan"
	public let repayTitle = "Repay"

	#warning("this values are mock")
	public let tokenIcon = "USDC"
	public let tokenBorrowAmountAndSymbol = "15 LINK"
	public let apy = "%3"
	public let borrowedAmount = "340 LINK"
	public let accruedFee = "60 LINK"
	public let totalDebt = "400 LINK"
}