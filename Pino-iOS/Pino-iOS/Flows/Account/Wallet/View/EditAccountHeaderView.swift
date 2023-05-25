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

	public var selectedAccountVM: AccountInfoViewModel! {
		didSet {
			setupAccountProperties()
		}
	}

	public static let headerReuseID = "editAccountHeaderView"

	// MARK: - Private Peroperties

	private let accountInfoStackview = UIStackView()
	private let accountAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let accountAvatar = UIImageView()
	private let setAvatarButton = UILabel()

	// MARK: - Private Methods

	private func setupView() {
		accountInfoStackview.addArrangedSubview(accountAvatarStackView)
		accountAvatarStackView.addArrangedSubview(avatarBackgroundView)
		accountAvatarStackView.addArrangedSubview(setAvatarButton)

		avatarBackgroundView.addSubview(accountAvatar)

		accountAvatarStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNewAvatar)))

		addSubview(accountInfoStackview)
	}

	private func setupConstraints() {
		accountInfoStackview.pin(
			.top(padding: 24),
			.horizontalEdges(padding: 16),
			.bottom(padding: 32)
		)
		avatarBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		accountAvatar.pin(
			.allEdges(padding: 16)
		)
	}

	private func setupStyles() {
		accountInfoStackview.axis = .vertical
		accountAvatarStackView.axis = .vertical

		accountAvatarStackView.alignment = .center
		accountInfoStackview.alignment = .center

		accountInfoStackview.spacing = 21
		accountAvatarStackView.spacing = 8

		avatarBackgroundView.layer.cornerRadius = 44

		setAvatarButton.font = .PinoStyle.mediumBody
		setAvatarButton.textColor = .Pino.primary
		setAvatarButton.text = editAccountVM.changeAvatarTitle
	}

	private func setupAccountProperties() {
		accountAvatar.image = UIImage(named: selectedAccountVM.profileImage)
		avatarBackgroundView.backgroundColor = UIColor(named: selectedAccountVM.profileImage)
	}

	@objc
	private func setNewAvatar() {
		newAvatarTapped()
	}
}
