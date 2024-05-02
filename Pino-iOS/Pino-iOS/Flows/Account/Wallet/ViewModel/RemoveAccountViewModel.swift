//
//  RemoveAccountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/27/23.
//

class RemoveAccountViewModel {
	// MARK: - Private Properties

	private let selectedAccount: AccountInfoViewModel

	private var isHDWallet: Bool {
		if selectedAccount.walletAccountInfoModel.wallet.type == Wallet.WalletType.hdWallet.rawValue {
			return true
		} else {
			return false
		}
	}

	// MARK: - Public Properties

	public let navigationDismissButtonIconName = "close"
	public let titleIconName = "remove_wallet"
	public let removeButtonTitle = "Remove"
	public let confirmActionSheetDescriptionText = ""
	public let confirmActionSheetButtonTitle = "Remove my wallet"
	public let dismissActionsheetButtonTitle = "Cancel"
	public let confirmActionSheetTitle = "Are you sure you want to remove your wallet?"
	public var titleText: String {
		"Remove \(selectedAccount.name)"
	}

	public var describtionText: String {
		if isHDWallet {
			return "Even after removing this wallet, you can recover it using the pass phrase."
		} else {
			return "Make sure you back up your wallet's private key for later use in Pino or another wallet."
		}
	}

	// MARK: - Public Init

	init(selectedAccount: AccountInfoViewModel) {
		self.selectedAccount = selectedAccount
	}
}
