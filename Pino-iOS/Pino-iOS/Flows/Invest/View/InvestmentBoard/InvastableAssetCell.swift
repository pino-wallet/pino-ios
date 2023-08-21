//
//  InvastableAssetCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class InvestableAssetCell: AssetsBoardCell {
	// MARK: - Public Properties

	public static let cellReuseID = "investableAssetCellID"

	public var investableAsset: InvestableAssetViewModel! {
		didSet {
			asset = investableAsset
			updateAssetAmount()
		}
	}

	// MARK: - Private Methods

	private func updateAssetAmount() {
		assetAmountDescriptionLabel.text = "APY"
		assetAmountLabel.text = investableAsset.formattedAPYAmount

		assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel

		switch investableAsset.volatilityType {
		case .profit:
			assetAmountLabel.textColor = .Pino.green
		case .loss:
			assetAmountLabel.textColor = .Pino.red
		case .none:
			assetAmountLabel.textColor = .Pino.secondaryLabel
		}
	}
}
