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

	public func build() -> WalletInfoViewModel {
		let coreDataManager = CoreDataManager()
		let wallet = coreDataManager.createWallet(
			id: id,
			address: selectedWallet.address,
			name: name ?? selectedWallet.name,
			avatarIcon: profileImage ?? selectedWallet.profileImage,
			avatarColor: profileColor ?? selectedWallet.profileColor,
			isSelected: selectedWallet.isSelected
		)
		return WalletInfoViewModel(walletInfoModel: wallet)
	}
}
