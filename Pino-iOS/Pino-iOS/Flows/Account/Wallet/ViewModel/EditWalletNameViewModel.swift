//
//  EditWalletNameViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/30/23.
//

class EditWalletNameViewModel {
	// MARK: - Closures

	public var didValidatedWalletName: (_ error: ValidateWalletNameErrorType) -> Void

	// MARK: - Public Properties

	public let pageTitle = "Wallet name"
	public let doneButtonName = "Done"
	public let walletNamePlaceHolder = "Enter name"
	public let walletRepeatedNameErrorText = "This wallet name is allready taken!"
	public let walletIsEmptyNameErrorText = "Wallet name cant be empty"

	public var selectedWalletID: String

	// MARK: - Private Properties

	private let walletManager = WalletManager()

	// MARK: - Initializers

	init(didValidatedWalletName: @escaping (_: ValidateWalletNameErrorType) -> Void, selectedWalletID: String) {
		self.didValidatedWalletName = didValidatedWalletName
		self.selectedWalletID = selectedWalletID
	}

	// MARK: - Public Methods

	public func validateWalletName(newWalletName: String) {
		if newWalletName.trimmingCharacters(in: .whitespaces).isEmpty {
			didValidatedWalletName(.isEmpty)
		} else {
			let wallets = walletManager.getWalletsFromUserDefaults()
			if wallets.contains(where: { $0.name == newWalletName && $0.id != selectedWalletID }) {
				didValidatedWalletName(.repeatedName)
			} else {
				didValidatedWalletName(.clear)
			}
		}
	}
}

extension EditWalletNameViewModel {
	public enum ValidateWalletNameErrorType: Error {
		case isEmpty
		case repeatedName
		case clear
	}
}
