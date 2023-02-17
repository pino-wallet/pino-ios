//
//  EditAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import Combine
import UIKit

class EditAccountView: UIView {
	// MARK: - Private Properties

	private let walletInfoStackview = UIStackView()
	private let walletAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let walletAvatar = UIImageView()
	private let setAvatarButton = UILabel()
	private let privateKeyStackView = UIStackView()
	private let privateKeyButton = PinoButton(style: .secondary)
	private let removeAccountButton = UIButton()
	private let walletVM: WalletInfoViewModel
	private let newAvatarTapped: () -> Void
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	@Published
	public var newAvatar: String
	public let newNameTextField = UITextField()

	// MARK: - Initializers

	init(walletVM: WalletInfoViewModel, newAvatarTapped: @escaping () -> Void) {
		self.newAvatarTapped = newAvatarTapped
		self.walletVM = walletVM
		self.newAvatar = walletVM.profileImage
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		walletInfoStackview.addArrangedSubview(walletAvatarStackView)
		walletInfoStackview.addArrangedSubview(newNameTextField)
		walletAvatarStackView.addArrangedSubview(avatarBackgroundView)
		walletAvatarStackView.addArrangedSubview(setAvatarButton)
		privateKeyStackView.addArrangedSubview(privateKeyButton)
		privateKeyStackView.addArrangedSubview(removeAccountButton)
		avatarBackgroundView.addSubview(walletAvatar)
		addSubview(walletInfoStackview)
		addSubview(privateKeyStackView)

		walletAvatarStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNewAvatar)))
	}

	private func setupStyle() {
		newNameTextField.text = walletVM.name
		setAvatarButton.text = "Set new avatar"
		privateKeyButton.title = "Show private key"
		removeAccountButton.setTitle("Remove account", for: .normal)
		walletAvatar.image = UIImage(named: walletVM.profileImage)
		privateKeyButton.setImage(UIImage(named: "private_key"), for: .normal)
		privateKeyButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 10)

		backgroundColor = .Pino.background
		avatarBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)
		setAvatarButton.textColor = .Pino.blue
		newNameTextField.textColor = .Pino.label
		removeAccountButton.setTitleColor(.Pino.red, for: .normal)

		newNameTextField.font = .PinoStyle.mediumBody
		removeAccountButton.titleLabel?.font = .PinoStyle.semiboldBody

		walletInfoStackview.axis = .vertical
		walletAvatarStackView.axis = .vertical
		privateKeyStackView.axis = .vertical

		walletAvatarStackView.alignment = .center
		walletInfoStackview.alignment = .center

		walletInfoStackview.spacing = 21
		walletAvatarStackView.spacing = 14
		privateKeyStackView.spacing = 48

		newNameTextField.borderStyle = .roundedRect
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
		newNameTextField.pin(
			.fixedHeight(48)
		)
		privateKeyStackView.pin(
			.bottom(padding: 48),
			.horizontalEdges(padding: 16)
		)
		newNameTextField.pin(
			.horizontalEdges
		)
	}

	private func setupBindings() {
		$newAvatar.sink { avatar in
			self.walletAvatar.image = UIImage(named: avatar)
			self.avatarBackgroundView.backgroundColor = UIColor(named: avatar)
		}.store(in: &cancellables)
	}

	@objc
	private func setNewAvatar() {
		newAvatarTapped()
	}
}
