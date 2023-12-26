//
//  CoinInfoEmptyStateFooterViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/26/23.
//

struct CoinInfoEmptyStateFooterViewModel {
	// MARK: - Public Properties

	public var titleText: String
	public var iconName: String
    public var descriptionText: String

	// MARK: - Initializers

    init(titleText: String, iconName: String, descriptionText: String) {
		self.titleText = titleText
		self.iconName = iconName
        self.descriptionText = descriptionText
	}
}
