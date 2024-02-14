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
	private let titleStackView = UIStackView()
	private let protocolImageView = UIImageView()
	private let assetNameLabel = UILabel()
	private let assetAmountLabel = UILabel()
	private let assetVolatilityLabel = UILabel()
	private let assetVolatilityIcon = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "investmentAssetCell"
	public var asset: InvestAssetViewModel? {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(assetStackView)
		assetStackView.addArrangedSubview(titleStackView)
		assetStackView.addArrangedSubview(assetAmountStackView)
		titleStackView.addArrangedSubview(assetNameLabel)
		titleStackView.addArrangedSubview(protocolImageView)
		assetAmountStackView.addArrangedSubview(assetAmountLabel)
		assetAmountStackView.addArrangedSubview(assetVolatilityIcon)
		assetAmountStackView.addArrangedSubview(assetVolatilityLabel)
	}

	private func setupStyle() {
		titleStackView.isSkeletonable = true
		assetAmountStackView.isSkeletonable = true
		if let asset {
			hideSkeletonView()
			assetNameLabel.text = asset.assetName
			assetAmountLabel.text = asset.formattedInvestmentAmount
			assetVolatilityLabel.text = asset.formattedAssetVolatility
			protocolImageView.image = UIImage(named: asset.protocolImage)

			switch asset.volatilityType {
			case .profit:
				assetVolatilityLabel.textColor = .Pino.green
				assetVolatilityIcon.tintColor = .Pino.green
				assetVolatilityIcon.image = UIImage(named: "arrow_up")
				assetVolatilityLabel.isHiddenInStackView = false
				assetVolatilityIcon.isHiddenInStackView = false
			case .loss:
				assetVolatilityLabel.textColor = .Pino.red
				assetVolatilityIcon.tintColor = .Pino.red
				assetVolatilityIcon.image = UIImage(named: "arrow_down")
				assetVolatilityLabel.isHiddenInStackView = false
				assetVolatilityIcon.isHiddenInStackView = false
			case .none:
				assetVolatilityLabel.isHiddenInStackView = true
				assetVolatilityIcon.isHiddenInStackView = true
			}
			titleStackView.layer.cornerRadius = 0
			assetAmountStackView.layer.cornerRadius = 0
		} else {
			titleStackView.layer.cornerRadius = 10
			assetAmountStackView.layer.cornerRadius = 12.5
			titleStackView.layer.masksToBounds = true
			assetAmountStackView.layer.masksToBounds = true
			showSkeletonView()
		}

		assetNameLabel.textColor = .Pino.secondaryLabel
		assetAmountLabel.textColor = .Pino.label

		assetNameLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.semiboldBody
		assetVolatilityLabel.font = .PinoStyle.mediumBody

		assetStackView.axis = .vertical

		assetStackView.spacing = 10
		assetAmountStackView.spacing = 2
		titleStackView.spacing = 4

		assetStackView.alignment = .leading
	}

	private func setupConstraint() {
		assetStackView.pin(
			.horizontalEdges(padding: 12),
			.centerY
		)
		assetVolatilityIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20),
			.bottom(padding: 5)
		)
		protocolImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)

		NSLayoutConstraint.activate([
			titleStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
			titleStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 45),
			assetAmountStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
			assetAmountStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 72),
		])
	}
}
