//
//  CreateImportOptionViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

struct AddNewWalletOptionViewModel {
	// MARK: - Public Properties

	public let AddNewWalletOption: AddNewWalletOptionModel

	public var title: String {
		AddNewWalletOption.title
	}

	public var description: String {
		AddNewWalletOption.descrption
	}

	public var iconName: String {
		AddNewWalletOption.iconName
	}

	public var page: AddNewWalletOptionModel.page {
		AddNewWalletOption.page
	}
}
