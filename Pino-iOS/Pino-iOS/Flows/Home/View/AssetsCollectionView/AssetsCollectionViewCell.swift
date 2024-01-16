//
//  AssetsCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import Kingfisher
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
	private let rightIconContainerView = UIView()
	private let rightIconImageView = UIImageView()
	private let assetAmountInDollorLabel = UILabel()
	private let spacerView = UIView()

	private var assetTitleLabelHeightconstraint: NSLayoutConstraint!
	private var assetAmountLabelHeightConstraint: NSLayoutConstraint!

	private let assetVolatilityLabel = UILabel()

	// MARK: Public Properties

	public static let cellReuseID = "assetCell"

	public var assetVM: AssetViewModel? {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
			toggleIsLoadingStyles()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(assetCardView)
		rightIconContainerView.addSubview(rightIconImageView)
		assetCardView.addSubview(assetStackView)
		assetStackView.addArrangedSubview(assetImage)
		assetStackView.addArrangedSubview(assetTitleStackView)
		assetStackView.addArrangedSubview(spacerView)
		assetStackView.addArrangedSubview(assetVolatilityStackView)
		assetStackView.addArrangedSubview(rightIconContainerView)
		assetTitleStackView.addArrangedSubview(assetTitleLabel)
		assetTitleStackView.addArrangedSubview(assetAmountLabel)
		assetVolatilityStackView.addArrangedSubview(assetAmountInDollorLabel)
		assetVolatilityStackView.addArrangedSubview(assetVolatilityLabel)
	}

	private func setupStyle() {
		setSkeletonable()

		assetTitleLabel.text = assetVM?.name
		assetAmountLabel.text = assetVM?.amount
		assetAmountLabel.lineBreakMode = .byTruncatingTail
		assetAmountInDollorLabel.text = assetVM?.amountInDollor
		assetVolatilityLabel.text = assetVM?.volatilityInDollor

		if assetVM?.securityMode ?? false {
			assetAmountLabel.font = .PinoStyle.boldTitle2
			assetAmountInDollorLabel.font = .PinoStyle.boldTitle1
			assetVolatilityLabel.font = .PinoStyle.boldTitle2

			assetVolatilityLabel.textColor = .Pino.gray3
			assetAmountLabel.textColor = .Pino.gray3
			assetAmountInDollorLabel.textColor = .Pino.secondaryLabel

		} else {
			assetAmountLabel.font = .PinoStyle.mediumFootnote
			assetAmountInDollorLabel.font = .PinoStyle.mediumCallout
			assetVolatilityLabel.font = .PinoStyle.mediumFootnote

			assetAmountLabel.textColor = .Pino.secondaryLabel
			assetAmountInDollorLabel.textColor = .Pino.label

			switch assetVM?.volatilityType ?? .none {
			case .profit:
				assetVolatilityLabel.textColor = .Pino.green
			case .loss:
				assetVolatilityLabel.textColor = .Pino.red
			case .none:
				assetVolatilityLabel.textColor = .Pino.secondaryLabel
			}
		}

		if let assetVM, !assetVM.isVerified {
			assetImage.image = UIImage(named: assetVM.customAssetImage)
		} else {
			assetImage.kf.indicatorType = .activity
			assetImage.kf.setImage(with: assetVM?.image)
		}

		backgroundColor = .Pino.background
		assetCardView.backgroundColor = .Pino.secondaryBackground
		assetImage.backgroundColor = .Pino.background

		assetTitleLabel.textColor = .Pino.label
		assetTitleLabel.font = .PinoStyle.mediumCallout
		assetTitleLabel.lineBreakMode = .byTruncatingTail

		assetStackView.axis = .horizontal
		assetStackView.alignment = .center
		assetTitleStackView.axis = .vertical
		assetTitleStackView.spacing = 14
		assetTitleStackView.alignment = .leading
		assetVolatilityStackView.axis = .vertical
		assetVolatilityStackView.spacing = 4

		assetStackView.spacing = 10

		assetCardView.layer.cornerRadius = 12
		assetImage.layer.cornerRadius = 22

		assetImage.layer.masksToBounds = true

		assetAmountInDollorLabel.textAlignment = .right
		assetAmountInDollorLabel.lineBreakMode = .byTruncatingTail
		assetVolatilityLabel.textAlignment = .right
		assetVolatilityLabel.lineBreakMode = .byTruncatingTail

		rightIconImageView.image = UIImage(named: "chevron_right")
		rightIconImageView.tintColor = .Pino.gray3

		updateStyleWithAssetType()
	}

	private func updateStyleWithAssetType() {
		guard let isPositionToken = assetVM?.isPosition else {
			disablePositionStyles()
			return
		}
		if isPositionToken == true {
			assetCardView.layer.borderWidth = 1
			assetCardView.layer.borderColor = UIColor.Pino.borderGray.cgColor

			assetVolatilityStackView.isHidden = true
			rightIconContainerView.isHidden = false
		} else {
			disablePositionStyles()
		}
	}

	private func disablePositionStyles() {
		assetCardView.layer.borderWidth = 0
		assetVolatilityStackView.isHidden = false
		rightIconContainerView.isHidden = true
	}

	private func setSkeletonable() {
		assetImage.isSkeletonable = true
		assetTitleLabel.isSkeletonable = true
		assetAmountLabel.isSkeletonable = true
	}

	private func setupConstraint() {
		assetTitleLabelHeightconstraint = assetTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
		assetAmountLabelHeightConstraint = assetAmountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12)

		contentView.pin(.allEdges(padding: 0))
		assetCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		assetStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 7),
			.fixedHeight(50)
		)
		assetImage.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		rightIconContainerView.pin(.fixedWidth(24))
		rightIconImageView.pin(.fixedWidth(24), .fixedHeight(24), .centerY)

		NSLayoutConstraint.activate([
			assetTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 130),
			assetAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 56),
			assetAmountInDollorLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
			assetVolatilityLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
			assetTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 170),
			assetAmountLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 170),
			assetAmountInDollorLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
			assetVolatilityLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
			assetAmountInDollorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
			assetVolatilityLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
			assetTitleLabelHeightconstraint,
			assetAmountLabelHeightConstraint,
		])
	}

	private func toggleIsLoadingStyles() {
		if assetVM == nil {
			assetTitleLabelHeightconstraint.constant = 14
			assetAmountLabelHeightConstraint.constant = 12
			assetTitleStackView.spacing = 14
			layoutIfNeeded()
		} else {
			assetTitleLabelHeightconstraint.constant = 24
			assetAmountLabelHeightConstraint.constant = 18
			assetTitleStackView.spacing = 4
			layoutIfNeeded()
		}
	}
}
