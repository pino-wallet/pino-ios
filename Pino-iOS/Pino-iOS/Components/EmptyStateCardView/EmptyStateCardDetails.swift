//
//  EmptyStateCardDetails.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 12/26/23.
//

extension EmptyStateCardView {
	public struct EmptyStateCardViewProperties: Equatable {
		public let imageName: String
		public let title: String
		public let description: String
		public let buttonTitle: String
	}
}

extension EmptyStateCardView.EmptyStateCardViewProperties {
	public static let borrow = EmptyStateCardView.EmptyStateCardViewProperties(
		imageName: "no_borrow",
		title: "No collateral",
		description: "To get a loan, you must first provide at least one asset as collateral.",
		buttonTitle: "Add collateral"
	)
	public static let invest = EmptyStateCardView.EmptyStateCardViewProperties(
		imageName: "no_invest",
		title: "No investment",
		description: "Maximize your earnings by investing in high-yield DeFi opportunities.",
		buttonTitle: "Invest now"
	)
}
