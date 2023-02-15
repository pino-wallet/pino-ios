//
//  WalletViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import Foundation

class WalletsViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedWallet: WalletInfoViewModel!
	@Published
	public var walletsList: [WalletInfoViewModel]!

	// MARK: - Private Properties

	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		getWallets()
	}

	// MARK: - Public Methods

	public func updateSelectedWallet(with selectedWallet: WalletInfoViewModel) {
		self.selectedWallet = selectedWallet
		saveSelectedWalletInUserDefaults(selectedWallet)
	}

	public func editWallet(id: String, newName: String?, newImage: String?, newColor: String?) {
		guard let walletIndex = walletsList.firstIndex(where: { $0.id == id })
		else { fatalError("No wallet found with this ID") }
		let editedWalletModel = WalletInfoModel(
			id: id,
			name: newName ?? walletsList[walletIndex].name,
			address: walletsList[walletIndex].address,
			profileImage: newImage ?? walletsList[walletIndex].profileImage,
			profileColor: newColor ?? walletsList[walletIndex].profileColor,
			balance: walletsList[walletIndex].walletInfoModel.balance
		)
		let editedWalletViewModel = WalletInfoViewModel(walletInfoModel: editedWalletModel)
		walletsList[walletIndex] = editedWalletViewModel
		saveWalletsInUserDefaults(walletsList)

		if id == selectedWallet.id {
			updateSelectedWallet(with: editedWalletViewModel)
		}
	}

	// MARK: - Private Methods

	private func getWallets() {
		// Request to get wallets
		let walletsModel = getWalletsFromUserDefaults()
		walletsList = walletsModel.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
		if let selectedWallet = getSelectedWalletFromUserDefaults() {
			self.selectedWallet = selectedWallet
		} else {
			guard let firstWallet = walletsList.first else { fatalError("No wallet found") }
			updateSelectedWallet(with: firstWallet)
		}
	}

	public func getWalletsFromUserDefaults() -> [WalletInfoModel] {
		guard let encodedWallets = UserDefaults.standard.data(forKey: "wallets") else { return [] }
		do {
			return try JSONDecoder().decode([WalletInfoModel].self, from: encodedWallets)
		} catch {
			print(error)
			return []
		}
	}

	private func getSelectedWalletFromUserDefaults() -> WalletInfoViewModel? {
		guard let encodedWallet = UserDefaults.standard.data(forKey: "selectedWallet") else { return nil }
		do {
			let walletModel = try JSONDecoder().decode(WalletInfoModel.self, from: encodedWallet)
			return WalletInfoViewModel(walletInfoModel: walletModel)
		} catch {
			return nil
		}
	}

	private func saveSelectedWalletInUserDefaults(_ selectedWallet: WalletInfoViewModel) {
		do {
			let encodedWallet = try JSONEncoder().encode(selectedWallet.walletInfoModel)
			UserDefaults.standard.set(encodedWallet, forKey: "selectedWallet")
		} catch {
			UserDefaults.standard.set(nil, forKey: "selectedWallet")
		}
	}

	private func saveWalletsInUserDefaults(_ wallets: [WalletInfoViewModel]) {
		let walletsModel = wallets.compactMap { $0.walletInfoModel }
		do {
			let encodedWallets = try JSONEncoder().encode(walletsModel)
			UserDefaults.standard.set(encodedWallets, forKey: "wallets")
		} catch {
			UserDefaults.standard.set([], forKey: "wallets")
		}
	}
}
