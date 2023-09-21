//
//  BorrowableAssetcell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

class BorrowableAssetCell: AssetsBoardCell {
	// MARK: - Public Properties

	public static let cellReuseID = "borrowableCellReuseID"

	public var borrowableAssetVM: BorrowableAssetViewModel? {
		didSet {
			asset = borrowableAssetVM
			setCellValues()
		}
	}

	// MARK: - Private Methods

	private func setCellValues() {
		guard let borrowableAssetVM else {
			isLoading = true
			return
		}
		assetAmountLabel.text = borrowableAssetVM.formattedAPYAmount

		assetAmountDescriptionLabel.text = "APY"
		assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel

		switch borrowableAssetVM.volatilityType {
		case .profit:
			assetAmountLabel.textColor = .Pino.green
		case .loss:
			assetAmountLabel.textColor = .Pino.red
		case .none:
			assetAmountLabel.textColor = .Pino.secondaryLabel
		}

		isLoading = false
	}
}
