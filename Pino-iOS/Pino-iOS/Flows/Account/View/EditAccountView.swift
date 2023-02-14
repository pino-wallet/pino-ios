//
//  EditAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import UIKit

class EditAccountView: UIView {
	// MARK: - Private Properties

	private let walletInfoStackview = UIStackView()
	private let walletAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let walletAvatar = UIImageView()
	private let walletNameTextField = UITextField()
	private let setAvatarButton = UIButton()

	private let walletVM: WalletInfoViewModel

	// MARK: - Initializers

	init(walletVM: WalletInfoViewModel) {
		self.walletVM = walletVM
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		walletInfoStackview.addArrangedSubview(walletAvatarStackView)
		walletInfoStackview.addArrangedSubview(walletNameTextField)
		walletAvatarStackView.addArrangedSubview(avatarBackgroundView)
		walletAvatarStackView.addArrangedSubview(setAvatarButton)
		avatarBackgroundView.addSubview(walletAvatar)
		addSubview(walletInfoStackview)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		walletNameTextField.text = walletVM.name
		walletAvatar.image = UIImage(named: walletVM.profileImage)
		avatarBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)
		setAvatarButton.setTitle("Set new avatar", for: .normal)
		setAvatarButton.setTitleColor(.Pino.blue, for: .normal)
		walletNameTextField.layer.borderColor = UIColor.Pino.gray5.cgColor

		walletNameTextField.borderStyle = .roundedRect

		walletNameTextField.textColor = .Pino.label
		walletNameTextField.font = .PinoStyle.mediumBody

		walletInfoStackview.axis = .vertical
		walletAvatarStackView.axis = .vertical

		walletAvatarStackView.alignment = .center
		walletInfoStackview.alignment = .fill

		walletInfoStackview.spacing = 21
		walletAvatarStackView.spacing = 14

		avatarBackgroundView.layer.cornerRadius = 44
	}

	private func setupConstraint() {
		walletInfoStackview.pin(
			.top(padding: 82),
			.horizontalEdges(padding: 16)
		)
		avatarBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		walletAvatar.pin(
			.allEdges(padding: 16)
		)
		walletNameTextField.pin(
			.fixedHeight(48)
		)
	}
}
