//
//  SettingCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//

import UIKit

public class SettingCell: UICollectionViewCell {
	// MARK: Private Properties

	private let settingCardView = UIView()
	private let settingImage = UIImageView()
	private let titleStackView = UIStackView()
	private let titleLabel = UILabel()
	private let detailStackView = UIStackView()
	private let descriptionLabel = UILabel()
	private let detailIcon = UIImageView()
	private let separatorLine = UIView()

	// MARK: Public Properties

	public static let cellReuseID = "settingCell"

	public var settingVM: SettingViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	public var style: Style = .regular {
		didSet {
			updateStyle()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(settingCardView)
		settingCardView.addSubview(titleStackView)
		settingCardView.addSubview(detailStackView)
		settingCardView.addSubview(separatorLine)
		titleStackView.addArrangedSubview(settingImage)
		titleStackView.addArrangedSubview(titleLabel)
		detailStackView.addArrangedSubview(descriptionLabel)
		detailStackView.addArrangedSubview(detailIcon)
	}

	private func setupStyle() {
		titleLabel.text = settingVM.title
		descriptionLabel.text = settingVM.description
		settingImage.image = UIImage(named: settingVM.image)
		detailIcon.image = UIImage(named: "arrow_right")

		detailIcon.tintColor = .Pino.gray3

		separatorLine.backgroundColor = .Pino.gray3

		titleLabel.font = .PinoStyle.mediumBody
		descriptionLabel.font = .PinoStyle.mediumBody

		titleLabel.textColor = .Pino.label
		descriptionLabel.textColor = .Pino.gray2

		settingCardView.backgroundColor = .Pino.secondaryBackground

		titleStackView.axis = .horizontal
		detailStackView.axis = .horizontal

		detailStackView.alignment = .center
		titleStackView.alignment = .center

		titleStackView.spacing = 16
		detailStackView.spacing = 2

		settingCardView.layer.cornerRadius = 8
	}

	private func setupConstraint() {
		settingCardView.pin(
			.verticalEdges,
			.horizontalEdges(padding: 16)
		)
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
		separatorLine.pin(
			.bottom,
			.trailing,
			.leading(padding: 62),
			.fixedHeight(0.5)
		)
	}

	private func updateStyle() {
		switch style {
		case .regular:
			separatorLine.isHidden = false
			settingCardView.layer.cornerRadius = 0
		case .singleCell:
			separatorLine.isHidden = true
			settingCardView.layer.cornerRadius = 8
		case .firstCell:
			separatorLine.isHidden = false
			settingCardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		case .lastCell:
			separatorLine.isHidden = true
			settingCardView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
		}
	}
}

extension SettingCell {
	public enum Style {
		case regular
		case singleCell
		case firstCell
		case lastCell
	}
}
