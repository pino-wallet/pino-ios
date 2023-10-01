//
//  UserInvestmentAssetCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class UserInvestmentAssetCell: AssetsBoardCell {
	// MARK: - Public Properties

	public static let cellReuseID = "UserInvestmentCellID"

	public var investmentAsset: InvestAssetViewModel! {
		didSet {
			asset = investmentAsset
			updateAssetAmount()
		}
	}

	// MARK: - Private Methods

	private func updateAssetAmount() {
		assetAmountLabel.text = investmentAsset.formattedInvestmentAmount
		switch investmentAsset.volatilityType {
		case .profit:
			assetAmountDescriptionLabel.text = "+\(investmentAsset.formattedAssetVolatility)"
			assetAmountDescriptionLabel.textColor = .Pino.green
		case .loss:
			assetAmountDescriptionLabel.text = "-\(investmentAsset.formattedAssetVolatility)"
			assetAmountDescriptionLabel.textColor = .Pino.red
		case .none:
			assetAmountDescriptionLabel.text = investmentAsset.formattedAssetVolatility
			assetAmountDescriptionLabel.textColor = .Pino.secondaryLabel
		}

		assetAmountLabel.textColor = .Pino.label
	}
}
