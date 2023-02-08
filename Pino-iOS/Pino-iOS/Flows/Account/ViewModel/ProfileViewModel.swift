//
//  ProfileViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import Combine

class ProfileViewModel {
	public var walletInfo: WalletInfoViewModel!
	public var accountSettings: [SettingViewModel]!
	public var generalSettings: [SettingViewModel]!

	private var walletAPIClient = WalletAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	init() {
		getWalletInfo()
		setSettings()
	}

	private func getWalletInfo() {
		// Request to get wallet info
		walletAPIClient.walletInfo().sink { completed in
			switch completed {
			case .finished:
				print("Wallet info received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { walletInfo in
			self.walletInfo = WalletInfoViewModel(walletInfoModel: walletInfo)
		}.store(in: &cancellables)
	}

	private func setSettings() {
		accountSettings = [
			SettingViewModel(id: "0", image: "Sand", title: "Wallets", description: nil),
		]
		generalSettings = [
			SettingViewModel(id: "0", image: "Sand", title: "Currency", description: "USD -US Dollar"),
			SettingViewModel(id: "1", image: "Sand", title: "Notification", description: nil),
			SettingViewModel(id: "2", image: "Sand", title: "Security lock", description: nil),
			SettingViewModel(id: "3", image: "Sand", title: "Recover phrase", description: nil),
			SettingViewModel(id: "4", image: "Sand", title: "Support", description: nil),
			SettingViewModel(id: "5", image: "Sand", title: "About pino", description: nil),
		]
	}
}
