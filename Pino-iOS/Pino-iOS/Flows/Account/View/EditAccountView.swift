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
	private let setAvatarButton = UIButton()
	private let privateKeyStackView = UIStackView()
	private let privateKeyButton = PinoButton(style: .secondary)
	private let removeAccountButton = UIButton()
	private let walletVM: WalletInfoViewModel

	// MARK: - Public Properties

	public let walletNameTextField = UITextField()

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
		privateKeyStackView.addArrangedSubview(privateKeyButton)
		privateKeyStackView.addArrangedSubview(removeAccountButton)
		avatarBackgroundView.addSubview(walletAvatar)
		addSubview(walletInfoStackview)
		addSubview(privateKeyStackView)
	}

	private func setupStyle() {
		walletNameTextField.text = walletVM.name
		setAvatarButton.setTitle("Set new avatar", for: .normal)
		privateKeyButton.title = "Show private key"
		removeAccountButton.setTitle("Remove account", for: .normal)
		walletAvatar.image = UIImage(named: walletVM.profileImage)
		privateKeyButton.setImage(UIImage(named: "private_key"), for: .normal)
		privateKeyButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 10)

		backgroundColor = .Pino.background
		avatarBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)
		setAvatarButton.setTitleColor(.Pino.blue, for: .normal)
		walletNameTextField.textColor = .Pino.label
		walletNameTextField.backgroundColor = .Pino.secondaryBackground
		removeAccountButton.setTitleColor(.Pino.red, for: .normal)

		walletNameTextField.font = .PinoStyle.mediumBody
		removeAccountButton.titleLabel?.font = .PinoStyle.semiboldBody

		walletInfoStackview.axis = .vertical
		walletAvatarStackView.axis = .vertical
		privateKeyStackView.axis = .vertical

		walletAvatarStackView.alignment = .center
		walletInfoStackview.alignment = .fill

		walletInfoStackview.spacing = 21
		walletAvatarStackView.spacing = 14
		privateKeyStackView.spacing = 48

		walletNameTextField.borderStyle = .roundedRect
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
		privateKeyStackView.pin(
			.bottom(padding: 48),
			.horizontalEdges(padding: 16)
		)
	}
}
