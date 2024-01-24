//
//  MyAddressCell.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import UIKit

class UserAddressCell: UICollectionViewCell {
	// MARK: - Public Properties

	public var walletVM: AccountInfoViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public static let cellReuseID = "MyAddressCellID"

	// MARK: - Private Propeties

	private let mainStackView = UIStackView()
	private let walletImageBackground = UIView()
	private let walletImageView = UIImageView()
	private let titleStackView = UIStackView()
	private let walletNameLabel = UILabel()
	private let walletETHBalanceLabel = UILabel()

	// MARK: - Private Methods

	private func setupView() {
		addSubview(mainStackView)
		mainStackView.addArrangedSubview(walletImageBackground)
		mainStackView.addArrangedSubview(titleStackView)
		walletImageBackground.addSubview(walletImageView)
		titleStackView.addArrangedSubview(walletNameLabel)
		titleStackView.addArrangedSubview(walletETHBalanceLabel)
	}

	private func setupStyles() {
		walletNameLabel.text = walletVM.name
		walletETHBalanceLabel.text = walletVM.ethBalance
		walletImageView.image = UIImage(named: walletVM.profileImage)
		walletImageBackground.backgroundColor = UIColor(named: walletVM.profileColor)

		walletNameLabel.textColor = .Pino.label
		walletETHBalanceLabel.textColor = .Pino.secondaryLabel

		walletNameLabel.font = .PinoStyle.semiboldSubheadline
		walletETHBalanceLabel.font = .PinoStyle.mediumSubheadline

		titleStackView.axis = .vertical

		mainStackView.spacing = 8

		walletImageBackground.layer.cornerRadius = 22
	}

	private func setupConstraints() {
		mainStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges,
			.fixedWidth(contentView.frame.width - 28)
		)
		walletImageView.pin(
			.allEdges(padding: 10)
		)
		walletImageBackground.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		walletNameLabel.pin(
			.fixedHeight(28)
		)
		walletETHBalanceLabel.pin(
			.fixedHeight(16)
		)
	}
}
