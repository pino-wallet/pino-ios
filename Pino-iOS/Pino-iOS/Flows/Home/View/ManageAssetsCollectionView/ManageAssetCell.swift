//
//  ManageAssetCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/14/23.
//

import Kingfisher
import UIKit

public class ManageAssetCell: UICollectionViewCell {
	// MARK: Private Properties

	private let assetCardView = UIView()
	private let assetStackView = UIStackView()
	private let assetImage = UIImageView()
	private let assetTitleStackView = UIStackView()
	private let assetTitleLabel = UILabel()
	private let assetAmountLabel = UILabel()
	private let selectAssetSwitch = UISwitch()

	// MARK: Public Properties

	public static let cellReuseID = "manageAssetCell"

	public var assetVM: AssetViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Public Methods

	public func toggleAssetSwitch() {
		selectAssetSwitch.setOn(!isSwitchOn(), animated: true)
	}

	public func isSwitchOn() -> Bool {
		selectAssetSwitch.isOn
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(assetCardView)
		assetCardView.addSubview(assetStackView)
		assetCardView.addSubview(selectAssetSwitch)
		assetStackView.addArrangedSubview(assetImage)
		assetStackView.addArrangedSubview(assetTitleStackView)
		assetTitleStackView.addArrangedSubview(assetTitleLabel)
		assetTitleStackView.addArrangedSubview(assetAmountLabel)
	}

	private func setupStyle() {
		assetTitleLabel.text = assetVM.name
		assetAmountLabel.text = assetVM.amount

		if assetVM.isVerified {
			assetImage.kf.indicatorType = .activity
			assetImage.kf.setImage(with: assetVM.image)
		} else {
			assetImage.image = UIImage(named: assetVM.customAssetImage)
		}

		backgroundColor = .Pino.background
		assetCardView.backgroundColor = .Pino.secondaryBackground
		assetImage.backgroundColor = .Pino.background

		assetTitleLabel.textColor = .Pino.label
		assetAmountLabel.textColor = .Pino.secondaryLabel

		assetTitleLabel.font = .PinoStyle.mediumCallout
		assetAmountLabel.font = .PinoStyle.mediumFootnote

		assetStackView.axis = .horizontal
		assetTitleStackView.axis = .vertical

		assetStackView.spacing = 10

		assetTitleStackView.alignment = .leading

		assetImage.layer.cornerRadius = 22
		assetCardView.layer.cornerRadius = 12

		selectAssetSwitch.onTintColor = .Pino.green3
		selectAssetSwitch.setOn(assetVM.isSelected, animated: false)
		selectAssetSwitch.isUserInteractionEnabled = false
	}

	private func setupConstraint() {
		assetCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		assetTitleStackView.pin(
			.verticalEdges
		)
		assetStackView.pin(
			.centerY,
			.leading(padding: 16)
		)
		selectAssetSwitch.pin(
			.centerY,
			.trailing(padding: 16)
		)
		assetImage.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		assetTitleLabel.pin(
			.fixedHeight(22)
		)
		assetAmountLabel.pin(
			.fixedHeight(18)
		)
	}
}
