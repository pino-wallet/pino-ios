//
//  AddNewWalletOptionsViewModel.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import Foundation

struct AddNewWalletViewModel {
	// MARK: - Public Properties

	public let AddNewWalletOptions: [AddNewWalletOptionModel?] = [
		AddNewWalletOptionModel(
			title: "Create a new wallet",
			descrption: "Generate a new account",
			iconName: "arrow_right",
			page: .Create
		),
		AddNewWalletOptionModel(
			title: "Import wallet",
			descrption: "Import an existing wallet",
			iconName: "arrow_right",
			page: .Import
		),
	]

	public let pageTitle = "Create / Import wallet"

	// MARK: - Public Methods

	public func addNewWalletWithAddress(_ address: String) {
		let walletManager = WalletManager()
		walletManager.addNewWalletWith(address: address)
	}
}
