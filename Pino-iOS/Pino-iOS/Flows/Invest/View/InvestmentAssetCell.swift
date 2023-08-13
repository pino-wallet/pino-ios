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
	public var asset: String! {
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
		assetNameLabel.text = "USDT"
		assetAmountLabel.text = "$1,100"
		assetVolatilityLabel.text = "$40"
		assetVolatilityIcon.image = UIImage(named: "arrow_up")

		assetNameLabel.textColor = .Pino.secondaryLabel
		assetAmountLabel.textColor = .Pino.label
		assetVolatilityLabel.textColor = .Pino.green
		assetVolatilityIcon.tintColor = .Pino.green

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
