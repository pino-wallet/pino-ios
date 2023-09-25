//
//  InvestmentAssetCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/13/23.
//

import UIKit

public class InvestmentAssetCell: UICollectionViewCell {
	// MARK: Private Properties

	private let assetStackView = UIStackView()
	private let assetAmountStackView = UIStackView()
	private let assetNameLabel = UILabel()
	private let assetAmountLabel = UILabel()
	private let assetVolatilityLabel = UILabel()
	private let assetVolatilityIcon = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "investmentAssetCell"
	public var asset: InvestAssetViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(assetStackView)
		assetStackView.addArrangedSubview(assetNameLabel)
		assetStackView.addArrangedSubview(assetAmountStackView)
		assetAmountStackView.addArrangedSubview(assetAmountLabel)
		assetAmountStackView.addArrangedSubview(assetVolatilityIcon)
		assetAmountStackView.addArrangedSubview(assetVolatilityLabel)
	}

	private func setupStyle() {
		assetNameLabel.text = asset.assetName
		assetAmountLabel.text = asset.formattedAssetAmount
		assetVolatilityLabel.text = asset.formattedAssetVolatility

		assetNameLabel.textColor = .Pino.secondaryLabel
		assetAmountLabel.textColor = .Pino.label

		switch asset.volatilityType {
		case .profit:
			assetVolatilityLabel.textColor = .Pino.green
			assetVolatilityIcon.tintColor = .Pino.green
			assetVolatilityIcon.image = UIImage(named: "arrow_up")
		case .loss:
			assetVolatilityLabel.textColor = .Pino.red
			assetVolatilityIcon.tintColor = .Pino.red
			assetVolatilityIcon.image = UIImage(named: "arrow_down")
		case .none:
			assetVolatilityLabel.isHidden = true
			assetVolatilityIcon.isHidden = true
		}

		assetNameLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.semiboldBody
		assetVolatilityLabel.font = .PinoStyle.mediumBody

		assetStackView.axis = .vertical
		assetStackView.spacing = 10
		assetAmountStackView.spacing = 2
	}

	private func setupConstraint() {
		assetStackView.pin(
			.allEdges(padding: 12)
		)
		assetVolatilityIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
	}
}
