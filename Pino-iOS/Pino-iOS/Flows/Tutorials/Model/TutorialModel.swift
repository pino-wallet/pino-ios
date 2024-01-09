//
//  TutorialModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/27/23.
//

import Foundation

struct TutorialModel {
	// MARK: - Public Properties

	public let title: String
	public let desc: String
	public let lottieFile: String

	public static let tutorials: [TutorialModel] = [
		.init(
			title: "Easy asset conversion",
			desc: "Easily convert your assets through a minimal swap interface.",
			lottieFile: "SwapEasyAssetConversion"
		),
		.init(
			title: "Save on Swaps",
			desc: "Get the best rates for your order from leading DEX aggregators.",
			lottieFile: "SwapSaveOnSwaps"
		),
		.init(
			title: "Loans Made Easy",
			desc: "Get loans directly through top lending protocols like Compound and Aave.",
			lottieFile: "BorrowLoansMadeEasy"
		),
		.init(
			title: "Ensure Loan Safety",
			desc: "Effortlessly monitor your loan positions to avoid unexpected liquidations.",
			lottieFile: "BorrowEnsureLoanSafety"
		),
		.init(
			title: "Simple Yield Earning",
			desc: "Invest in reliable yield-bearing opportunities and seamlessly manage them.",
			lottieFile: "InvestSimpleYieldEarning"
		),
		.init(
			title: "Easy Profit Tracking",
			desc: "Track your USD-based investment value and true profit over time.",
			lottieFile: "InvestEasyProfitTracking"
		),
	]
}
