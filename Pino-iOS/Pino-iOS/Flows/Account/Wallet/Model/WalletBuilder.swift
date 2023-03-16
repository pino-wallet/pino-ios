//
//  WalletBuilder.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/16/23.
//

class WalletBuilder {
	// MARK: - Private Properties

	private(set) var id: String
	private(set) var name: String?
	private(set) var profileImage: String?
	private(set) var profileColor: String?
	private(set) var selectedWallet: WalletInfoViewModel!

	// MARK: - Initializers

	init(walletInfo: WalletInfoViewModel) {
		self.selectedWallet = walletInfo
		self.id = selectedWallet.id
	}

	// MARK: - Public Methods

	public func setProfileName(_ name: String) {
		self.name = name
	}

	public func setProfileImage(_ image: String) {
		profileImage = image
	}

	public func setProfileColor(_ color: String) {
		profileColor = color
	}

	public func build() -> WalletInfoModel {
		WalletInfoModel(
			id: id,
			name: name ?? selectedWallet.name,
			address: selectedWallet.address,
			profileImage: profileImage ?? selectedWallet.profileImage,
			profileColor: profileColor ?? selectedWallet.profileColor,
			balance: selectedWallet.walletInfoModel.balance,
			isSelected: selectedWallet.isSelected
		)
	}
}
