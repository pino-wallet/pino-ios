//
//  ManageAssetPositionsCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/15/24.
//

import UIKit

public class ManageAssetPositionsCell: UICollectionViewCell {
	// MARK: Private Properties

	private let positionsCardView = UIView()
	private let positionsStackView = UIStackView()
	private let positionsImage = UIImageView()
	private let positionsTitleStackView = UIStackView()
	private let positionsTitleLabel = UILabel()
	private let positionsCountLabel = UILabel()
	private let selectAssetSwitch = UISwitch()

	// MARK: Public Properties

	public static let cellReuseID = "manageAssetPositionsCell"

	public var positionsVM: ManageAssetPositionsViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Public Methods

	public func toggleAssetSwitch() {
		let isSelected = !isSwitchOn()
		selectAssetSwitch.setOn(isSelected, animated: true)
	}

	public func isSwitchOn() -> Bool {
		selectAssetSwitch.isOn
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(positionsCardView)
		positionsCardView.addSubview(positionsStackView)
		positionsCardView.addSubview(selectAssetSwitch)
		positionsStackView.addArrangedSubview(positionsImage)
		positionsStackView.addArrangedSubview(positionsTitleStackView)
		positionsTitleStackView.addArrangedSubview(positionsTitleLabel)
		positionsTitleStackView.addArrangedSubview(positionsCountLabel)
	}

	private func setupStyle() {
		positionsTitleLabel.text = positionsVM.positionsTitle
		positionsCountLabel.text = String(positionsVM.positionsCount)

		positionsImage.image = UIImage(named: positionsVM.positionsImage)

		backgroundColor = .Pino.background
		positionsCardView.backgroundColor = .Pino.secondaryBackground

		positionsTitleLabel.textColor = .Pino.label
		positionsCountLabel.textColor = .Pino.secondaryLabel

		positionsTitleLabel.font = .PinoStyle.mediumCallout
		positionsCountLabel.font = .PinoStyle.mediumFootnote

		positionsStackView.axis = .horizontal
		positionsTitleStackView.axis = .vertical

		positionsStackView.spacing = 10

		positionsTitleStackView.alignment = .leading

		positionsImage.layer.cornerRadius = 22
		positionsCardView.layer.cornerRadius = 12

		selectAssetSwitch.onTintColor = .Pino.green3
		selectAssetSwitch.setOn(positionsVM.isSelected, animated: false)
		selectAssetSwitch.isUserInteractionEnabled = false
	}

	private func setupConstraint() {
		positionsCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		positionsTitleStackView.pin(
			.verticalEdges
		)
		positionsStackView.pin(
			.centerY,
			.leading(padding: 16)
		)
		selectAssetSwitch.pin(
			.centerY,
			.trailing(padding: 16)
		)
		positionsImage.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		positionsTitleLabel.pin(
			.fixedHeight(22)
		)
		positionsCountLabel.pin(
			.fixedHeight(18)
		)
	}
}
