//
//  importAccountsCell.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

public class ImportAccountCell: UICollectionViewCell {
	// MARK: Private Properties

	private let accountCardView = UIView()
	private let accountInfoStackView = UIStackView()
	private let accountIconBackgroundView = UIView()
	private let accountIcon = UIImageView()
	private let titleStackView = UIStackView()
	private let accountName = UILabel()
	private let accountBalance = UILabel()
	private let editButton = UIButton()

	// MARK: Public Properties

	public static let cellReuseID = "walletCell"
	public var editButtonTapped: (() -> Void)!

	public var accountVM: ActiveAccountViewModel! {
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
		accountInfoStackView.addArrangedSubview(accountIconBackgroundView)
		accountInfoStackView.addArrangedSubview(titleStackView)
		accountInfoStackView.addArrangedSubview(editButton)
		titleStackView.addArrangedSubview(accountName)
		titleStackView.addArrangedSubview(accountBalance)
		accountIconBackgroundView.addSubview(accountIcon)

		editButton.addAction(UIAction(handler: { _ in
			self.editButtonTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		accountName.text = accountVM.name
		accountBalance.text = accountVM.balance
		accountIcon.image = UIImage(named: accountVM.profileImage)
		editButton.setImage(UIImage(named: "dots-menu"), for: .normal)

		accountIconBackgroundView.backgroundColor = UIColor(named: accountVM.profileColor)
		accountCardView.backgroundColor = .Pino.secondaryBackground
		accountCardView.layer.borderColor = UIColor.Pino.primary.cgColor
		editButton.tintColor = .Pino.gray3

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
		editButton.pin(
			.fixedWidth(28),
			.fixedHeight(28)
		)
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
}

extension ImportAccountCell {
	public enum Style {
		case regular
		case selected
	}
}
