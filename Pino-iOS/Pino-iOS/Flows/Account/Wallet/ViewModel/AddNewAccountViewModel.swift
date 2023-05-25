//
//  AddNewWalletOptionsViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import Foundation

struct AddNewAccountViewModel {
	// MARK: - Public Properties

	public let AddNewAccountOptions: [AddNewAccountOptionModel?] = [
		AddNewAccountOptionModel(
			title: "Create a new account",
			descrption: "Generate a new account",
			iconName: "arrow_right",
			page: .Create
		),
		AddNewAccountOptionModel(
			title: "Import wallet",
			descrption: "Import an existing wallet",
			iconName: "arrow_right",
			page: .Import
		),
	]

	public let pageTitle = "Create / Import Account"
}
