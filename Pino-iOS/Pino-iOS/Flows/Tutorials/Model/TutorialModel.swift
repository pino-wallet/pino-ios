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
			title: "Easy Asset Conversion",
			desc: "Convert your assets through a minimal swap interface.",
			lottieFile: "SwapEasyAssetConversion"
		),
		.init(
			title: "Save on Swaps",
			desc: "Get the best rates from leading DEX aggregators.",
			lottieFile: "SwapSaveOnSwaps"
		),
		.init(
			title: "Maximize Your Earns",
			desc: "Invest in top yield-bearing DeFi opportunities easily.",
			lottieFile: "InvestSimpleYieldEarning"
		),
		.init(
			title: "Easy Profit Tracking",
			desc: "Track the performance of your investments effortlessly.",
			lottieFile: "InvestEasyProfitTracking"
		)
//		.init(
//			title: "Get Loan Easily",
//			desc: "Get loans directly through top lending protocols.",
//			lottieFile: "BorrowLoansMadeEasy"
//		),
//		.init(
//			title: "Ensure Loan Safety",
//			desc: "Monitor and manage your loan positions easily.",
//			lottieFile: "BorrowEnsureLoanSafety"
//		),
	]
}
