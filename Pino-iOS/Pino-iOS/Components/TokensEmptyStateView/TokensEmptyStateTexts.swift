//
//  ManageAssetEmptyStateViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/14/24.
//

import Foundation

extension TokensEmptyStateView {
	struct TokensEmptyStateTexts {
		// MARK: - Public Properties

		public var titleImageName: String
		public var titleText: String
		public var descriptionText: String
		public var buttonTitle: String?
	}
}

extension TokensEmptyStateView.TokensEmptyStateTexts {
	public static let manageAsset = TokensEmptyStateView.TokensEmptyStateTexts(
		titleImageName: "no_results",
		titleText: "Not found",
		descriptionText: "Didn’t see your crypto?",
		buttonTitle: "Import"
	)
	public static let noResults = TokensEmptyStateView.TokensEmptyStateTexts(
		titleImageName: "no_results",
		titleText: "No results",
		descriptionText: "No assets found with that name",
		buttonTitle: nil
	)
}
