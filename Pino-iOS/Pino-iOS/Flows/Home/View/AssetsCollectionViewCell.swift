//
//  AssetsCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import UIKit

public class AssetsCollectionViewCell: UICollectionViewCell {
	// MARK: Private Properties

	private let assetCardView = UIView()
	private let assetStackView = UIStackView()
	private let assetImage = UIImageView()
	private let assetTitleStackView = UIStackView()
	private let assetTitleLabel = UILabel()
	private let assetAmountLabel = UILabel()
	private let assetVolatilityStackView = UIStackView()
	private let assetAmountInDollorLabel = UILabel()
	private let assetVolatilityLabel = UILabel()

	// MARK: Public Properties

	public static let cellReuseID = "assetCell"

	public var asset: String! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(assetCardView)
		assetCardView.addSubview(assetStackView)
		assetCardView.addSubview(assetVolatilityStackView)
		assetStackView.addArrangedSubview(assetImage)
		assetStackView.addArrangedSubview(assetTitleStackView)
		assetTitleStackView.addArrangedSubview(assetTitleLabel)
		assetTitleStackView.addArrangedSubview(assetAmountLabel)
		assetVolatilityStackView.addArrangedSubview(assetAmountInDollorLabel)
		assetVolatilityStackView.addArrangedSubview(assetVolatilityLabel)
	}

	private func setupStyle() {
		assetTitleLabel.text = "Chainlink"
		assetAmountLabel.text = "10.04 LINK"
		assetAmountInDollorLabel.text = "$1,530"
		assetVolatilityLabel.text = "+$10"

		backgroundColor = .Pino.background
		assetCardView.backgroundColor = .Pino.secondaryBackground
		assetImage.backgroundColor = .Pino.background

		assetTitleLabel.textColor = .Pino.label
		assetAmountLabel.textColor = .Pino.secondaryLabel
		assetAmountInDollorLabel.textColor = .Pino.label
		assetVolatilityLabel.textColor = .Pino.green

		assetTitleLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.mediumFootnote
		assetAmountInDollorLabel.font = .PinoStyle.mediumCallout
		assetVolatilityLabel.font = .PinoStyle.mediumFootnote

		assetStackView.axis = .horizontal
		assetTitleStackView.axis = .vertical
		assetVolatilityStackView.axis = .vertical

		assetStackView.spacing = 10
		assetTitleStackView.spacing = 4
		assetVolatilityStackView.spacing = 9

		assetVolatilityStackView.alignment = .trailing

		assetCardView.layer.cornerRadius = 12
		assetImage.layer.cornerRadius = 22
	}

	private func setupConstraint() {
		assetCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		assetStackView.pin(
			.centerY,
			.leading(padding: 14)
		)
		assetVolatilityStackView.pin(
			.centerY,
			.trailing(padding: 14)
		)
		assetImage.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
	}
}
