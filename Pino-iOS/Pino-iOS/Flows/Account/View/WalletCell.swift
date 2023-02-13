//
//  WalletCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import UIKit

public class WalletCell: UICollectionViewCell {
	// MARK: Private Properties

	private let walletCardView = UIView()
	private let walletInfoStackView = UIStackView()
	private let walletIconBackgroundView = UIView()
	private let walletIcon = UIImageView()
	private let titleStackView = UIStackView()
	private let walletname = UILabel()
	private let walletBalance = UILabel()
	private let editIcon = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "walletCell"

	public var walletVM: WalletInfoViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: Private UI Methods

	private func setupView() {
		contentView.addSubview(walletCardView)
		walletCardView.addSubview(walletInfoStackView)
		walletCardView.addSubview(editIcon)
		walletInfoStackView.addArrangedSubview(walletIconBackgroundView)
		walletInfoStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(walletname)
		titleStackView.addArrangedSubview(walletBalance)
		walletIconBackgroundView.addSubview(walletIcon)
	}

	private func setupStyle() {
		walletname.text = walletVM.name
		walletBalance.text = "100"
		walletIcon.image = UIImage(named: walletVM.profileImage)
		editIcon.image = UIImage(named: "arrow_right")

		editIcon.tintColor = .Pino.gray3

		walletIconBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)

		walletname.font = .PinoStyle.mediumBody
		walletBalance.font = .PinoStyle.mediumBody

		walletname.textColor = .Pino.label
		walletBalance.textColor = .Pino.gray2

		walletCardView.backgroundColor = .Pino.secondaryBackground

		titleStackView.axis = .vertical
		walletInfoStackView.axis = .horizontal

		walletInfoStackView.alignment = .center
		titleStackView.alignment = .center

		titleStackView.spacing = 4
		walletInfoStackView.spacing = 8

		walletCardView.layer.cornerRadius = 12
		walletIconBackgroundView.layer.cornerRadius = 22
	}

	private func setupConstraint() {
		walletCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16)
		)
		walletInfoStackView.pin(
			.leading(padding: 14),
			.centerY
		)
		walletIconBackgroundView.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		walletIcon.pin(
			.allEdges(padding: 10)
		)
		editIcon.pin(
			.fixedWidth(28),
			.fixedHeight(28),
			.trailing(padding: 14),
			.centerY
		)
	}
}
