//
//  AddNewWalletOptionsViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import Foundation

class AddNewAccountViewModel {
	// MARK: - Public Properties

	@Published
	public var AddNewAccountOptions: [AddNewAccountOptionModel?] = [
		AddNewAccountOptionModel(
			title: "Create a new account",
			descrption: "Generate a new account",
			iconName: "arrow_right",
			type: .Create,
			isLoading: false
		),
		AddNewAccountOptionModel(
			title: "Import wallet",
			descrption: "Import an existing wallet",
			iconName: "arrow_right",
			type: .Import,
			isLoading: false
		),
	]

	public let pageTitle = "Create / Import Account"

	// MARK: - Public Methods

	public func updateAddNewAccountOption(optionType: AddNewAccountOptionModel.type, loadingStatus: Bool) {
		let optionIndex = AddNewAccountOptions.firstIndex(where: { $0?.type == optionType })
		AddNewAccountOptions[optionIndex!]?.isLoading = loadingStatus
	}
}
