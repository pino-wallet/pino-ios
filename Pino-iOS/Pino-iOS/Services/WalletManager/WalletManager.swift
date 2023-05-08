//
//  ProfileName.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 5/3/23.
//

import Foundation

struct WalletManager {
	// MARK: - Public Typealiases

	public typealias WalletsListType = [WalletInfoModel]

	// MARK: - Initializers

	init() {}

	// MARK: - Public Methods

	public func setSelectedState(wallet: WalletInfoModel) -> WalletsListType {
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

	public func removeWallet(wallet: WalletInfoModel) -> WalletsListType {
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

	public func editWallet(newWallet: WalletInfoModel) -> WalletsListType {
		var wallets = getWalletsFromUserDefaults()

		guard let currentWalletIndex = wallets.firstIndex(where: { $0.id == newWallet.id }) else {
			fatalError("Cant find wallet with this wallet id")
		}
		wallets[currentWalletIndex] = newWallet
		saveWalletsInUserDefaults(wallets)

		return wallets
	}

	public func addNewWalletWith(address: String) -> WalletsListType {
		var availableAvatars = Constants.avatars
		var wallets = getWalletsFromUserDefaults()
		for (walletIndex, wallet) in wallets.enumerated() {
			wallets[walletIndex].isSelected(false)
			let walletFruitName = Constants.fruitNames[wallet.profileImage]
			if wallet.name == walletFruitName {
				availableAvatars = availableAvatars.filter { $0 != wallet.profileImage }
			}
		}
		let avatarName = availableAvatars.randomElement() ?? "green_apple"
		guard let avatarFruitName = Constants.fruitNames[avatarName] else {
			fatalError("Cant find avatar fruit name")
		}

		#warning("this address is for testing and we should refactor this code")
		let newWallet = WalletInfoModel(
			id: "\(Int(wallets.last!.id)! + 1)",
			name: "\(String(describing: avatarFruitName))",
			address: address,
			profileImage: avatarName,
			profileColor: avatarName,
			balance: "0",
			isSelected: true
		)
		wallets.append(newWallet)
		saveWalletsInUserDefaults(wallets)

		return wallets
	}

	public func getWalletsFromUserDefaults() -> WalletsListType {
		guard let encodedWallets = UserDefaults.standard.data(forKey: "wallets") else {
			fatalError("No wallet found in user defaults")
		}
		do {
			return try JSONDecoder().decode(WalletsListType.self, from: encodedWallets)
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	// MARK: - Private Methods

	private func saveWalletsInUserDefaults(_ wallets: WalletsListType) {
		do {
			let encodedWallets = try JSONEncoder().encode(wallets)
			UserDefaults.standard.set(encodedWallets, forKey: "wallets")
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
