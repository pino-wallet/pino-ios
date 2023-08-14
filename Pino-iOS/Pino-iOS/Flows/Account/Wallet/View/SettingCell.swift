//
//  SettingCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import UIKit

public class SettingCell: GroupCollectionViewCell {
	// MARK: Private Properties

	private let settingImage = UIImageView()
	private let titleStackView = UIStackView()
	private let titleLabel = UILabel()
	private let detailStackView = UIStackView()
	private let descriptionLabel = UILabel()
	private let detailIcon = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "settingCell"

	public var settingVM: SettingsViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		cardView.addSubview(titleStackView)
		cardView.addSubview(detailStackView)
		titleStackView.addArrangedSubview(settingImage)
		titleStackView.addArrangedSubview(titleLabel)
		detailStackView.addArrangedSubview(descriptionLabel)
		detailStackView.addArrangedSubview(detailIcon)
	}

	private func setupStyle() {
		titleLabel.text = settingVM.title
		descriptionLabel.text = settingVM.description
		settingImage.image = UIImage(named: settingVM.image)
		detailIcon.image = UIImage(named: "chevron_right")

		detailIcon.tintColor = .Pino.gray3

		titleLabel.font = .PinoStyle.mediumBody
		descriptionLabel.font = .PinoStyle.mediumBody

		titleLabel.textColor = .Pino.label
		descriptionLabel.textColor = .Pino.gray2

		titleStackView.axis = .horizontal
		detailStackView.axis = .horizontal

		detailStackView.alignment = .center
		titleStackView.alignment = .center

		titleStackView.spacing = 16
		detailStackView.spacing = 2

		settingImage.layer.cornerRadius = 7
		settingImage.layer.masksToBounds = true
	}

	private func setupConstraint() {
		titleStackView.pin(
			.leading(padding: 16),
			.centerY
		)
		detailStackView.pin(
			.trailing(padding: 8),
			.centerY
		)
		settingImage.pin(
			.fixedWidth(30),
			.fixedHeight(30)
		)
		detailIcon.pin(
			.fixedWidth(18),
			.fixedHeight(18)
		)

		NSLayoutConstraint.deactivate([separatorLeadingConstraint])
		separatorLine.pin(
			.leading(padding: 62)
		)
	}
}
