//
//  ManageAssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

public struct ManageAssetViewModel {
	// MARK: - Public Properties

	public var manageAssetModel: ManageAssetModel!

	public var image: String {
		manageAssetModel.image
	}

	public var name: String {
		manageAssetModel.name
	}

	public var amount: String {
		manageAssetModel.amount + manageAssetModel.codeName
	}
}
