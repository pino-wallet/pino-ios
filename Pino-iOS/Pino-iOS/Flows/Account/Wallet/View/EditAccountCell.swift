//
//  EditAccountCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

import UIKit

class EditAccountCell: GroupCollectionViewCell {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleLabelContainerView = UIView()
	private let titleLabel = PinoLabel(style: .info, text: "")
	private let betWeenView = UIView()
	private let describtionLabel = PinoLabel(style: .description, text: "")
	private let rightIconImageView = UIImageView()

	// MARK: - Public Properties

	public static let cellReuseID = "editAccountCellReuseID"
	public var editAccountOptionVM: EditAccountOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
			setupStyle()
		}
	}

	public var cellDescribtionText: String! {
		didSet {
			describtionLabel.text = cellDescribtionText
			describtionLabel.lineBreakMode = .byTruncatingTail
			describtionLabel.textAlignment = .right
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		titleLabelContainerView.addSubview(titleLabel)

		mainStackView.addArrangedSubview(titleLabelContainerView)
		mainStackView.addArrangedSubview(betWeenView)
		mainStackView.addArrangedSubview(describtionLabel)
		mainStackView.addArrangedSubview(rightIconImageView)

		cardView.addSubview(mainStackView)
	}

	private func setupStyle() {
		titleLabel.text = editAccountOptionVM.title
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byWordWrapping

		rightIconImageView.image = UIImage(named: editAccountOptionVM.rightIconName)

		describtionLabel.font = .PinoStyle.mediumBody
		describtionLabel.textColor = .Pino.gray2
		describtionLabel.numberOfLines = 1

		mainStackView.axis = .horizontal
		mainStackView.alignment = .center
	}

	private func setupConstraints() {
		titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
		titleLabelContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		betWeenView.widthAnchor.constraint(equalToConstant: 30).isActive = true

		mainStackView.pin(
			.verticalEdges(padding: 12),
			.horizontalEdges(padding: 16),
			.fixedWidth(contentView.frame.width - 32)
		)
		rightIconImageView.pin(
			.fixedWidth(24),
			.fixedHeight(24)
		)
		titleLabel.pin(.allEdges(padding: 0))
		NSLayoutConstraint.deactivate([separatorLeadingConstraint])
		separatorLine.pin(
			.leading(padding: 16)
		)
	}
}
