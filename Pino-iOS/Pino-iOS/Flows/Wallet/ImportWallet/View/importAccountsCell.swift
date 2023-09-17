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
	private let accountAddress = UILabel()

	// MARK: Public Properties

	public static let cellReuseID = "importAccountCell"

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
		accountInfoStackView.addArrangedSubview(accountAddress)
		titleStackView.addArrangedSubview(accountName)
		titleStackView.addArrangedSubview(accountBalance)
		accountIconBackgroundView.addSubview(accountIcon)
	}

	private func setupStyle() {
		accountName.text = accountVM.name
		accountBalance.text = accountVM.balance
		accountAddress.text = accountVM.address.shortenedString(characterCountFromStart: 4, characterCountFromEnd: 4)
		accountIcon.image = UIImage(named: accountVM.profileImage)

		accountIconBackgroundView.backgroundColor = UIColor(named: accountVM.profileColor)
		accountCardView.backgroundColor = .Pino.secondaryBackground

		accountName.textColor = .Pino.label
		accountBalance.textColor = .Pino.secondaryLabel
		accountAddress.textColor = .Pino.label

		accountName.font = .PinoStyle.mediumCallout
		accountBalance.font = .PinoStyle.mediumFootnote
		accountAddress.font = .PinoStyle.mediumCallout

		titleStackView.axis = .vertical
		accountInfoStackView.axis = .horizontal

		accountInfoStackView.alignment = .top
		titleStackView.alignment = .leading

		titleStackView.spacing = 4
		accountInfoStackView.spacing = 12

		accountCardView.layer.cornerRadius = 12
		accountIconBackgroundView.layer.cornerRadius = 22
		accountCardView.layer.borderWidth = 1
		updateStyle()
	}

	private func setupConstraint() {
		accountCardView.pin(
			.verticalEdges(padding: 4),
			.horizontalEdges,
			.fixedWidth(contentView.frame.width)
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
		accountAddress.pin(
			.fixedHeight(24)
		)
		accountName.pin(
			.fixedHeight(24)
		)
	}

	private func updateStyle() {
		switch style {
		case .regular:
			accountCardView.layer.borderColor = UIColor.Pino.gray3.cgColor
		case .selected:
			accountCardView.layer.borderColor = UIColor.Pino.primary.cgColor
		}
	}
}

extension ImportAccountCell {
	public enum Style {
		case regular
		case selected
	}
}
