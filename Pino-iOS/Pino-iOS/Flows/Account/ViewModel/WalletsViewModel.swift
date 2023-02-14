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

	// MARK: - Private Methods

	private func getWallets() {
		// Request to get wallets
		walletAPIClient.walletsList().sink { completed in
			switch completed {
			case .finished:
				print("Wallets received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { wallets in
			self.walletsList = wallets.walletsList.compactMap { WalletInfoViewModel(walletInfoModel: $0) }
			if let selectedWallet = self.getSelectedWalletFromUserDefaults() {
				self.selectedWallet = selectedWallet
			} else {
				guard let firstWallet = self.walletsList.first else { fatalError("No wallet found") }
				self.updateSelectedWallet(with: firstWallet)
			}
		}.store(in: &cancellables)
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
}
