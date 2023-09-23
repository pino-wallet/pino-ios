//
//  CollateralizableAssetCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

class CollateralizableAssetCell: AssetsBoardCell {
	// MARK: - Public Properties

	public static let cellReuseID = "collateralizableCellReuseID"

	public var collateralizableAssetVM: CollateralizableAssetViewModel? {
		didSet {
			asset = collateralizableAssetVM
			setCellValues()
		}
	}

	// MARK: - Private Methods

	private func setCellValues() {
        guard let collateralizableAssetVM else {
            isLoading = true
            return
        }
        
		assetAmountLabel.text = collateralizableAssetVM.usrAmountInToken
		assetAmountLabel.textColor = .Pino.label

		assetAmountDescriptionLabel.text = "Balance"
		assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel
        
        isLoading = false
	}
}
