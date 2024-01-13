//
//  CreateImportWalletCollectionViewCell.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import UIKit

class AddNewAccountCollectionViewCell: UICollectionViewCell {
	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let textStackView = UIStackView()
	private let betWeenStackView = UIStackView()
	private let iconStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: "")
	private let descriptionLabel = PinoLabel(style: .description, text: "")
	private let cellStatusContainerView = UIView()
	private let cellImageContainerView = UIView()
	private let cellLoadingContainerView = UIView()
	private let iconImageView = UIImageView()
	private var loadingView: PinoLoading!

	// MARK: - Public Properties

	public var addNewAccountOptionVM: AddNewAccountOptionViewModel! {
		didSet {
			setupView()
			setupConstraints()
			setupStyles()
		}
	}

	public static let cellReuseID = "createImportWalletCell"

	// MARK: - Private Methods

	private func setupView() {
		loadingView = PinoLoading(size: 28)

		textStackView.addArrangedSubview(titleLabel)
		textStackView.addArrangedSubview(descriptionLabel)

		cellImageContainerView.addSubview(iconImageView)
		cellLoadingContainerView.addSubview(loadingView)

		cellStatusContainerView.addSubview(cellImageContainerView)
		cellStatusContainerView.addSubview(cellLoadingContainerView)

		contentView.addSubview(mainStackView)
		mainStackView.axis = .horizontal
		mainStackView.addArrangedSubview(textStackView)
		mainStackView.addArrangedSubview(betWeenStackView)
		mainStackView.addArrangedSubview(cellStatusContainerView)
	}

	private func setupStyles() {
		toggleCellLoading(addNewAccountOptionVM.isLoading)

		contentView.layer.cornerRadius = 12
		contentView.layer.backgroundColor = UIColor.Pino.white.cgColor

		titleLabel.text = addNewAccountOptionVM.title
		titleLabel.font = .PinoStyle.semiboldCallout

		descriptionLabel.text = addNewAccountOptionVM.description
		descriptionLabel.font = .PinoStyle.mediumSubheadline

		iconImageView.image = UIImage(named: addNewAccountOptionVM.iconName)?.withRenderingMode(.alwaysTemplate)
		iconImageView.tintColor = .Pino.gray3

		textStackView.axis = .vertical
		textStackView.spacing = 4
		textStackView.distribution = .fillEqually
	}

	private func toggleCellLoading(_ loadingStatus: Bool) {
		if loadingStatus {
			isUserInteractionEnabled = false
			cellLoadingContainerView.isHidden = false
			cellImageContainerView.isHidden = true
		} else {
			isUserInteractionEnabled = true
			cellLoadingContainerView.isHidden = true
			cellImageContainerView.isHidden = false
		}
	}

	private func setupConstraints() {
		mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

		cellImageContainerView.pin(.fixedWidth(28))
		iconImageView.pin(.fixedWidth(28), .fixedHeight(28), .centerY())
		loadingView.pin(.centerY())
		cellImageContainerView.pin(.allEdges(padding: 0))
		cellLoadingContainerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.allEdges(padding: 14))
	}
}
