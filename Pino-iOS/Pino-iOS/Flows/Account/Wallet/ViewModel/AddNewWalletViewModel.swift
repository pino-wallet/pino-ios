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

	public func addNewWallet() {
		var wallets = getWalletsFromUserDefaults()
		for index in 0 ..< wallets.count {
			wallets[index].isSelected(false)
		}
		let avatar = Constants.avatars.randomElement() ?? "green_apple"
		let newWallet = WalletInfoModel(
			id: "\(Int(wallets.last!.id)! + 1)",
			name: "Wallet \(wallets.count + 1)",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: avatar,
			profileColor: avatar,
			balance: "0",
			isSelected: true
		)
		wallets.append(newWallet)
		saveWalletsInUserDefaults(wallets)
	}

	// MARK: - Private Methods

	private func getWalletsFromUserDefaults() -> [WalletInfoModel] {
		guard let encodedWallets = UserDefaults.standard.data(forKey: "wallets") else {
			fatalError("No wallet found in user defaults")
		}
		do {
			return try JSONDecoder().decode([WalletInfoModel].self, from: encodedWallets)
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	private func saveWalletsInUserDefaults(_ wallets: [WalletInfoModel]) {
		do {
			let encodedWallets = try JSONEncoder().encode(wallets)
			UserDefaults.standard.set(encodedWallets, forKey: "wallets")
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
