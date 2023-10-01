//
//  WalletCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import UIKit

public class AccountCell: UICollectionViewCell {
	// MARK: Private Properties

	private let accountCardView = UIView()
	private let accountInfoStackView = UIStackView()
	private let accountIconBackgroundView = UIView()
	private let accountIcon = UIImageView()
	private let titleStackView = UIStackView()
	private let accountName = UILabel()
	private let accountBalance = UILabel()
	private let editButtonContainerView = UIView()
	private let editButtonImageView = UIImageView()

	// MARK: Public Properties

	public static let cellReuseID = "walletCell"
	public var editButtonTapped: (() -> Void)!

	public var accountVM: AccountInfoViewModel! {
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
		contentView.addSubview(accountCardView)
		accountCardView.addSubview(accountInfoStackView)
		editButtonContainerView.addSubview(editButtonImageView)
		accountInfoStackView.addArrangedSubview(accountIconBackgroundView)
		accountInfoStackView.addArrangedSubview(titleStackView)
		accountInfoStackView.addArrangedSubview(editButtonContainerView)
		titleStackView.addArrangedSubview(accountName)
		titleStackView.addArrangedSubview(accountBalance)
		accountIconBackgroundView.addSubview(accountIcon)

		let editButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(onEditButtonTap))
		editButtonContainerView.addGestureRecognizer(editButtonTapGesture)
	}

	private func setupStyle() {
		accountName.text = accountVM.name
		accountBalance.text = accountVM.balance
		accountIcon.image = UIImage(named: accountVM.profileImage)

		editButtonContainerView.backgroundColor = .Pino.background
		editButtonContainerView.layer.cornerRadius = 16

		editButtonImageView.image = UIImage(named: "edit_accounts")

		accountIconBackgroundView.backgroundColor = UIColor(named: accountVM.profileColor)
		accountCardView.backgroundColor = .Pino.secondaryBackground
		accountCardView.layer.borderColor = UIColor.Pino.primary.cgColor
		editButtonContainerView.tintColor = .Pino.gray3

		accountName.textColor = .Pino.label
		accountBalance.textColor = .Pino.secondaryLabel

		accountBalance.font = .PinoStyle.mediumFootnote

		titleStackView.axis = .vertical
		accountInfoStackView.axis = .horizontal

		accountInfoStackView.alignment = .center
		titleStackView.alignment = .leading

		titleStackView.spacing = 4
		accountInfoStackView.spacing = 8

		accountCardView.layer.cornerRadius = 12
		accountIconBackgroundView.layer.cornerRadius = 22

		updateStyle()
	}

	private func setupConstraint() {
		accountCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges(padding: 16),
			.fixedWidth(contentView.frame.width - 32)
		)
		accountInfoStackView.pin(
			.horizontalEdges(padding: 14),
			.centerY
		)
		accountIconBackgroundView.pin(
			.fixedWidth(44),
			.fixedHeight(44)
		)
		accountIcon.pin(
			.allEdges(padding: 6)
		)
		editButtonContainerView.pin(.fixedWidth(32), .fixedHeight(32))
		editButtonImageView.pin(.fixedWidth(24), .fixedHeight(24), .centerY, .centerX)
	}

	private func updateStyle() {
		switch style {
		case .regular:
			accountName.font = .PinoStyle.mediumCallout
			accountCardView.layer.borderWidth = 0
		case .selected:
			accountName.font = .PinoStyle.semiboldCallout
			accountCardView.layer.borderWidth = 1.2
		}
	}

	@objc
	private func onEditButtonTap() {
		editButtonTapped()
	}
}

extension AccountCell {
	public enum Style {
		case regular
		case selected
	}
}
