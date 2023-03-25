//
//  AccountHeaderView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/8/23.
//
import UIKit

class AccountHeaderView: UICollectionReusableView {
	// MARK: - Private Properties

	private let walletInfoStackview = UIStackView()
	private let walletNameStackView = UIStackView()
	private let walletIconBackgroundView = UIView()
	private let walletIcon = UIImageView()
	private let walletName = UILabel()
	private let walletAddress = UILabel()
	private let accountSettingsTitle = UILabel()

	// MARK: - Public Properties

	public static let headerReuseID = "accountHeader"

	public var walletInfoVM: WalletInfoViewModel! {
		didSet {
			setupView()
			setupStyle()
			setupConstraint()
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		walletInfoStackview.addArrangedSubview(walletIconBackgroundView)
		walletInfoStackview.addArrangedSubview(walletNameStackView)
		walletNameStackView.addArrangedSubview(walletName)
		walletNameStackView.addArrangedSubview(walletAddress)
		walletIconBackgroundView.addSubview(walletIcon)
		addSubview(walletInfoStackview)
		addSubview(accountSettingsTitle)
	}

	private func setupStyle() {
		walletName.text = walletInfoVM.name
		walletAddress.text = walletInfoVM.address.shortenedString(characterCount: 4)
		accountSettingsTitle.text = "Accounts"
		walletIcon.image = UIImage(named: walletInfoVM.profileImage)
		walletIconBackgroundView.backgroundColor = UIColor(named: walletInfoVM.profileColor)

		walletName.textColor = .Pino.label
		walletAddress.textColor = .Pino.secondaryLabel
		accountSettingsTitle.textColor = .Pino.secondaryLabel

		walletName.font = .PinoStyle.mediumTitle1
		walletAddress.font = .PinoStyle.mediumSubheadline
		accountSettingsTitle.font = .PinoStyle.mediumSubheadline

		walletInfoStackview.axis = .vertical
		walletNameStackView.axis = .vertical

		walletNameStackView.alignment = .center
		walletInfoStackview.alignment = .center

		walletInfoStackview.spacing = 8
		walletNameStackView.spacing = 2

		walletIconBackgroundView.layer.cornerRadius = 44
	}

	private func setupConstraint() {
		walletInfoStackview.pin(
			.top(padding: 24),
			.horizontalEdges(padding: 16)
		)
		walletIconBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		accountSettingsTitle.pin(
			.bottom(padding: 12),
			.horizontalEdges(padding: 16)
		)
		walletIcon.pin(
			.allEdges(padding: 16)
		)
	}
}
