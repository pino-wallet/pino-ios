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
	public let walletNameIsRepeatedError = "This wallet name is already taken!"
	public let walletNameIsEmptyError = "Wallet name cant be empty"

	public var selectedWallet: WalletInfoViewModel
	public var wallets: [WalletInfoViewModel]

	// MARK: - Initializers

	init(
		didValidatedWalletName: @escaping (_: ValidateWalletNameErrorType) -> Void,
		selectedWallet: WalletInfoViewModel,
		wallets: [WalletInfoViewModel]
	) {
		self.didValidatedWalletName = didValidatedWalletName
		self.selectedWallet = selectedWallet
		self.wallets = wallets
	}

	// MARK: - Public Methods

	public func validateWalletName(newWalletName: String) {
		if newWalletName.trimmingCharacters(in: .whitespaces).isEmpty {
			didValidatedWalletName(.isEmpty)
		} else {
			if wallets.contains(where: { $0.name == newWalletName && $0.id != selectedWallet.id }) {
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
