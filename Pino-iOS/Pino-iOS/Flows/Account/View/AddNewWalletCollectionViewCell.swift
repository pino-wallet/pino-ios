//
//  CreateImportWalletCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import UIKit

class AddNewWalletCollectionViewCell: UICollectionViewCell {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let textStackView = UIStackView()
	private let betWeenStackView = UIStackView()
	private let iconStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let iconImageContainerView = UIView()
	private let iconImageView = UIImageView()

	// MARK: - Public Properties

	public var addNewWalletOptionVM: AddNewWalletOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
		}
	}

	public static let cellReuseID = "createImportWalletCell"

	// MARK: - Private Methods

	private func setupView() {
		contentView.layer.cornerRadius = 12
		contentView.layer.backgroundColor = UIColor.Pino.white.cgColor

		titleLabel.text = addNewWalletOptionVM.title
		titleLabel.font = .PinoStyle.semiboldCallout

		descriptionLabel.text = addNewWalletOptionVM.description
		descriptionLabel.font = .PinoStyle.mediumSubheadline

		iconImageView.image = UIImage(named: addNewWalletOptionVM.iconName)
		iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
		iconImageView.tintColor = .secondaryLabel

		textStackView.axis = .vertical
		textStackView.spacing = 4
		textStackView.distribution = .fillEqually
		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionLabel)

		iconImageContainerView.addSubview(iconImageView)

		iconStackView.addArrangedSubview(iconImageContainerView)

		contentView.addSubview(mainStackView)
		mainStackView.axis = .horizontal
		mainStackView.addArrangedSubview(textStackView)
		mainStackView.addArrangedSubview(betWeenStackView)
		mainStackView.addArrangedSubview(iconStackView)
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

		iconImageContainerView.pin(.fixedWidth(28))
		iconImageView.pin(.fixedWidth(28), .fixedHeight(28), .centerY())
		mainStackView.pin(.allEdges(padding: 14))
	}
}
