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
	private let assetAmountInDollorLabel = UILabel()
	private let assetVolatilityLabel = UILabel()

	// MARK: Public Properties

	public static let cellReuseID = "assetCell"

	public var assetVM: AssetViewModel? {
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
		setSkeletonable()

		assetTitleLabel.text = assetVM?.name ?? "                  "
		assetAmountLabel.text = assetVM?.amount ?? "               "
		assetAmountInDollorLabel.text = assetVM?.amountInDollor ?? "               "
		assetVolatilityLabel.text = assetVM?.volatilityInDollor ?? "               "

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

		assetImage.kf.indicatorType = .activity
		assetImage.kf.setImage(with: assetVM?.image)

		backgroundColor = .Pino.background
		assetCardView.backgroundColor = .Pino.secondaryBackground
		assetImage.backgroundColor = .Pino.background

		assetTitleLabel.textColor = .Pino.label

		assetTitleLabel.font = .PinoStyle.mediumCallout

		assetStackView.axis = .horizontal
		assetTitleStackView.axis = .vertical
		assetVolatilityStackView.axis = .vertical

		assetStackView.spacing = 10

		assetVolatilityStackView.alignment = .trailing
		assetTitleStackView.alignment = .leading
		assetVolatilityStackView.alignment = .trailing
		assetTitleStackView.distribution = .equalCentering
		assetVolatilityStackView.distribution = .equalCentering

		assetCardView.layer.cornerRadius = 12
		assetImage.layer.cornerRadius = 22

		assetImage.layer.masksToBounds = true
	}

	private func setSkeletonable() {
		assetImage.isSkeletonable = true
		assetTitleLabel.isSkeletonable = true
		assetAmountLabel.isSkeletonable = true
		assetVolatilityLabel.isSkeletonable = true
		assetAmountInDollorLabel.isSkeletonable = true
	}

	private func setupConstraint() {
		assetCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		assetTitleStackView.pin(
			.top(padding: 4),
			.bottom(padding: 2)
		)
		assetStackView.pin(
			.centerY,
			.leading(padding: 14)
		)
		assetVolatilityStackView.pin(
			.verticalEdges(to: assetTitleStackView),
			.trailing(padding: 14)
		)
		assetImage.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		//        if assetVM != nil {
		//            assetTitleLabel.pin(
		//                .fixedHeight(22)
		//            )
		//            assetAmountLabel.pin(
		//                .fixedHeight(18)
		//            )
		//            assetAmountInDollorLabel.pin(
		//                .fixedHeight(22)
		//            )
		//            assetVolatilityLabel.pin(
		//                .fixedHeight(18)
		//            )
		//        }else {
		//            assetTitleLabel.pin(
		//                .fixedHeight(14)
		//            )
		//            assetAmountLabel.pin(
		//                .fixedHeight(14)
		//            )
		//            assetAmountInDollorLabel.pin(
		//                .fixedHeight(14)
		//            )
		//            assetVolatilityLabel.pin(
		//                .fixedHeight(14)
		//            )
		//        }
	}
}
