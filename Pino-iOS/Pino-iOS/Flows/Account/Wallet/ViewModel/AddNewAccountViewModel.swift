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
			title: "Create new wallet",
			descrption: "Generate a new wallet",
			iconName: "chevron_right",
			type: .Create,
			isLoading: false
		),
		AddNewAccountOptionModel(
			title: "Import wallet",
			descrption: "Import with private key",
			iconName: "chevron_right",
			type: .Import,
			isLoading: false
		),
	]

	public let pageTitle = "Create / Import wallet"

	// MARK: - Public Methods

	public func setLoadingStatusFor(optionType: AddNewAccountOptionModel.type, loadingStatus: Bool) {
		let optionIndex = AddNewAccountOptions.firstIndex(where: { $0?.type == optionType })
		AddNewAccountOptions[optionIndex!]?.isLoading = loadingStatus
	}
}
