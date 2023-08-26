//
//  UserCollateralizingAssetCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

class UserCollateralizingAssetCell: AssetsBoardCell {
	// MARK: - Public Properties

	public static let cellReuseID = "userCollateralizingCellReuseID"

	public var userCollateralizingAssetVM: UserCollateralizingAssetViewModel! {
		didSet {
			asset = userCollateralizingAssetVM
			setCellValues()
		}
	}

	// MARK: - Private Methods

	private func setCellValues() {
		assetAmountLabel.text = userCollateralizingAssetVM.userCollateralizingInToken
		assetAmountLabel.textColor = .Pino.label

		assetAmountDescriptionLabel.text = userCollateralizingAssetVM.userCollateralizingInDollars
		assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel
	}
}
