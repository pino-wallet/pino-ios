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
	private let editButton = UIButton()

	// MARK: Public Properties

	public static let cellReuseID = "walletCell"
	public var editButtonTapped: (() -> Void)?

	public var walletVM: WalletInfoViewModel! {
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
		contentView.addSubview(walletCardView)
		walletCardView.addSubview(walletInfoStackView)
		walletCardView.addSubview(editButton)
		walletInfoStackView.addArrangedSubview(walletIconBackgroundView)
		walletInfoStackView.addArrangedSubview(titleStackView)
		titleStackView.addArrangedSubview(walletname)
		titleStackView.addArrangedSubview(walletBalance)
		walletIconBackgroundView.addSubview(walletIcon)

		editButton.addAction(UIAction(handler: { _ in
			if let editButtonTapped = self.editButtonTapped {
				editButtonTapped()
			}
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		walletname.text = walletVM.name
		walletBalance.text = walletVM.balance
		walletIcon.image = UIImage(named: walletVM.profileImage)
		editButton.setImage(UIImage(named: "dots-menu"), for: .normal)

		walletIconBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)
		walletCardView.backgroundColor = .Pino.secondaryBackground
		walletCardView.layer.borderColor = UIColor.Pino.primary.cgColor
		editButton.tintColor = .Pino.gray3

		walletname.textColor = .Pino.label
		walletBalance.textColor = .Pino.secondaryLabel

		walletBalance.font = .PinoStyle.mediumFootnote

		titleStackView.axis = .vertical
		walletInfoStackView.axis = .horizontal

		walletInfoStackView.alignment = .center
		titleStackView.alignment = .leading

		titleStackView.spacing = 4
		walletInfoStackView.spacing = 8

		walletCardView.layer.cornerRadius = 12
		walletIconBackgroundView.layer.cornerRadius = 22

		updateStyle()
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
			.allEdges(padding: 6)
		)
		editButton.pin(
			.fixedWidth(28),
			.fixedHeight(28),
			.trailing(padding: 14),
			.centerY
		)
	}

	private func updateStyle() {
		switch style {
		case .regular:
			walletname.font = .PinoStyle.mediumCallout
			walletCardView.layer.borderWidth = 0
		case .selected:
			walletname.font = .PinoStyle.semiboldCallout
			walletCardView.layer.borderWidth = 1.2
		}
	}
}

extension WalletCell {
	public enum Style {
		case regular
		case selected
	}
}
