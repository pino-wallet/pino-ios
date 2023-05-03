//
//  EditAccountHeaderView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

import UIKit

class EditAccountHeaderView: UICollectionReusableView {
	// MARK: - Closures

	public var newAvatarTapped: () -> Void = {}

	// MARK: - Public Properties

	public var editAccountVM: EditAccountViewModel! {
		didSet {
			setupView()
			setupStyles()
			setupConstraints()
		}
	}

	public var selectedWalletVM: WalletInfoViewModel! {
		didSet {
			setupWalletProperties()
		}
	}

	public static let headerReuseID = "editAccountHeaderView"

	// MARK: - Private Peroperties

	private let walletInfoStackview = UIStackView()
	private let walletAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let walletAvatar = UIImageView()
	private let setAvatarButton = UILabel()

	// MARK: - Private Methods

	private func setupView() {
		walletInfoStackview.addArrangedSubview(walletAvatarStackView)
		walletAvatarStackView.addArrangedSubview(avatarBackgroundView)
		walletAvatarStackView.addArrangedSubview(setAvatarButton)

		avatarBackgroundView.addSubview(walletAvatar)

		walletAvatarStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNewAvatar)))

		addSubview(walletInfoStackview)
	}

	private func setupConstraints() {
		walletInfoStackview.pin(
			.top(padding: 24),
			.horizontalEdges(padding: 16),
			.bottom(padding: 32)
		)
		avatarBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		walletAvatar.pin(
			.allEdges(padding: 16)
		)
	}

	private func setupStyles() {
		walletInfoStackview.axis = .vertical
		walletAvatarStackView.axis = .vertical

		walletAvatarStackView.alignment = .center
		walletInfoStackview.alignment = .center

		walletInfoStackview.spacing = 21
		walletAvatarStackView.spacing = 8

		avatarBackgroundView.layer.cornerRadius = 44

		setAvatarButton.font = .PinoStyle.mediumBody
		setAvatarButton.textColor = .Pino.primary
		setAvatarButton.text = editAccountVM.changeAvatarTitle
	}

	private func setupWalletProperties() {
		walletAvatar.image = UIImage(named: selectedWalletVM.profileImage)
		avatarBackgroundView.backgroundColor = UIColor(named: selectedWalletVM.profileImage)
	}

	@objc
	private func setNewAvatar() {
		newAvatarTapped()
	}
}
