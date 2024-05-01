//
//  RemoveAccountViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/27/23.
//

class RemoveAccountViewModel {
	// MARK: - Private Properties

	private var selectedAccountName: String

	// MARK: - Public Properties

	public let navigationDismissButtonIconName = "close"
	public let titleIconName = "remove_wallet"
	public let describtionText =
		"Even after removing this wallet, you can recover it using the pass phrase."
	public let removeButtonTitle = "Remove"
	public let confirmActionSheetDescriptionText =
		""
	public let confirmActionSheetButtonTitle = "Remove my wallet"
	public let dismissActionsheetButtonTitle = "Cancel"
	public let confirmActionSheetTitle = "Are you sure you want to remove your wallet?"
	public var titleText: String {
		"Remove \(selectedAccountName)"
	}

	// MARK: - Public Init

	init(selectedAccountName: String) {
		self.selectedAccountName = selectedAccountName
	}
}
