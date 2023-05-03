//
//  ProfileName.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/3/23.
//

import Foundation

class WalletManager {
	// MARK: - Public Typealiases

	public typealias walletsListType = [WalletInfoModel]

	// MARK: - Initializers

	init() {}

	// MARK: - Public Methods

	public func updateSelectedWallet(wallet: WalletInfoModel) -> walletsListType {
		var wallets = getWalletsFromUserDefaults()
		for index in 0 ..< wallets.count {
			if wallets[index].id == wallet.id {
				wallets[index].isSelected(true)
			} else {
				wallets[index].isSelected(false)
			}
		}
		saveWalletsInUserDefaults(wallets)
		return wallets
	}

	public func removeWallet(wallet: WalletInfoModel) -> walletsListType {
		var wallets = getWalletsFromUserDefaults()
		if wallets.count > 1 {
			guard let walletIndex = wallets.firstIndex(where: { $0.id == wallet.id }) else {
				fatalError("No wallet found with this ID")
			}
			wallets.remove(at: walletIndex)
			if wallet.isSelected {
				wallets[0].isSelected(true)
			}
			saveWalletsInUserDefaults(wallets)
		}
		return wallets
	}

	public func editWallet(newWallet: WalletInfoModel) -> walletsListType {
		var newWallet = newWallet
		var wallets = getWalletsFromUserDefaults()

		guard let currentWalletIndex = wallets.firstIndex(where: { $0.id == newWallet.id }) else {
			fatalError("Cant find wallet with this wallet id")
		}
		let currentWallet = wallets[currentWalletIndex]

		let currentWalletFruitName = Constants.FruitNames[currentWallet.profileImage]
		// detect if user are changeing his wallet avatar
		if newWallet.profileImage != currentWallet.profileImage && currentWallet.name
			.contains(currentWalletFruitName!) {
			newWallet = setWalletNameFromWalletAvatar(newWallet: newWallet, currentWallet: currentWallet)
		}

		newWallet = renameNewWalletIfNeeded(wallets: wallets, newWallet: newWallet)
		wallets[currentWalletIndex] = newWallet
		saveWalletsInUserDefaults(wallets)

		return wallets
	}

	public func addNewWallet() -> walletsListType {
		var wallets = getWalletsFromUserDefaults()
		for index in 0 ..< wallets.count {
			wallets[index].isSelected(false)
		}
		let avatarName = Constants.avatars.randomElement() ?? "green_apple"
		guard let avatarFruitName = Constants.FruitNames[avatarName] else {
			fatalError("Cant find avatar fruit name")
		}

		#warning("this address is for testing and we should refactor this code")
		var newWallet = WalletInfoModel(
			id: "\(Int(wallets.last!.id)! + 1)",
			name: "\(String(describing: avatarFruitName))",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: avatarName,
			profileColor: avatarName,
			balance: "0",
			isSelected: true
		)
		newWallet = renameNewWalletIfNeeded(wallets: wallets, newWallet: newWallet)
		wallets.append(newWallet)
		saveWalletsInUserDefaults(wallets)

		return wallets
	}

	public func getWalletsFromUserDefaults() -> walletsListType {
		guard let encodedWallets = UserDefaults.standard.data(forKey: "wallets") else {
			fatalError("No wallet found in user defaults")
		}
		do {
			return try JSONDecoder().decode(walletsListType.self, from: encodedWallets)
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	// MARK: - Private Methods

	private func setWalletNameFromWalletAvatar(
		newWallet: WalletInfoModel,
		currentWallet: WalletInfoModel
	) -> WalletInfoModel {
		var newWallet = newWallet
		guard let newAvatarFruitName = Constants.FruitNames[newWallet.profileImage] else {
			fatalError("Cant find new avatar fruitname")
		}
		guard let currentAvatarFruitName = Constants.FruitNames[currentWallet.profileImage] else {
			fatalError("Cant find current avatar fruitname")
		}

		newWallet.name = newWallet.name.replacingOccurrences(of: currentAvatarFruitName, with: newAvatarFruitName)

		return newWallet
	}

	private func renameNewWalletIfNeeded(wallets: walletsListType, newWallet: WalletInfoModel) -> WalletInfoModel {
		var newWallet = newWallet
		var suffix = 1
		for wallet in wallets {
			if newWallet.name == wallet.name {
				newWallet.name = "\(newWallet.name) (\(suffix))"
				suffix = suffix + 1
			}
		}
		return newWallet
	}

	private func saveWalletsInUserDefaults(_ wallets: walletsListType) {
		do {
			let encodedWallets = try JSONEncoder().encode(wallets)
			UserDefaults.standard.set(encodedWallets, forKey: "wallets")
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
