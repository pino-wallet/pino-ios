//
//  EditAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/14/23.
//

import Combine
import UIKit

class EditAccountView: UIView {
	// MARK: - Closure

	public var navigateToRemoveAccountPageClosure: () -> Void

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
	private let showPrivateKeyTapped: () -> Void

	// MARK: - Public Properties

	@Published
	public var newAvatar: String
	public let walletNameTextFieldView = PinoTextFieldView(style: .normal)

	// MARK: - Initializers

	init(
		walletVM: WalletInfoViewModel,
		newAvatarTapped: @escaping () -> Void,
		navigateToRemoveAccountPageClosure: @escaping () -> Void,
		showPrivateKeyTapped: @escaping () -> Void
	) {
		self.newAvatarTapped = newAvatarTapped
		self.walletVM = walletVM
		self.newAvatar = walletVM.profileImage
		self.navigateToRemoveAccountPageClosure = navigateToRemoveAccountPageClosure
		self.showPrivateKeyTapped = showPrivateKeyTapped
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
		walletInfoStackview.addArrangedSubview(walletNameTextFieldView)
		walletAvatarStackView.addArrangedSubview(avatarBackgroundView)
		walletAvatarStackView.addArrangedSubview(setAvatarButton)
		privateKeyStackView.addArrangedSubview(privateKeyButton)
		privateKeyStackView.addArrangedSubview(removeAccountButton)
		avatarBackgroundView.addSubview(walletAvatar)
		addSubview(walletInfoStackview)
		addSubview(privateKeyStackView)

		walletAvatarStackView
			.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setNewAvatar)))
		privateKeyButton.addAction(UIAction(handler: { _ in
			self.showPrivateKeyTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		walletNameTextFieldView.text = walletVM.name
		walletNameTextFieldView.errorText = "Please enter wallet's name!"
		setAvatarButton.text = "Set new avatar"
		privateKeyButton.title = "Show private key"
		removeAccountButton.setTitle("Remove account", for: .normal)
		removeAccountButton.addTarget(self, action: #selector(navigateToRemoveAccountPage), for: .touchUpInside)
		walletAvatar.image = UIImage(named: walletVM.profileImage)
		privateKeyButton.setImage(UIImage(named: "private_key"), for: .normal)
		privateKeyButton.setConfiguraton(font: .PinoStyle.semiboldBody!, imagePadding: 10)

		backgroundColor = .Pino.background
		avatarBackgroundView.backgroundColor = UIColor(named: walletVM.profileColor)
		setAvatarButton.textColor = .Pino.blue
		removeAccountButton.setTitleColor(.Pino.red, for: .normal)

		removeAccountButton.titleLabel?.font = .PinoStyle.semiboldBody

		walletInfoStackview.axis = .vertical
		walletAvatarStackView.axis = .vertical
		privateKeyStackView.axis = .vertical

		walletAvatarStackView.alignment = .center
		walletInfoStackview.alignment = .center

		walletInfoStackview.spacing = 21
		walletAvatarStackView.spacing = 14
		privateKeyStackView.spacing = 48

		avatarBackgroundView.layer.cornerRadius = 44

		walletNameTextFieldView.textDidChange = {
			self.walletNameTextFieldView.style = .normal
		}
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
		privateKeyStackView.pin(
			.bottom(padding: 48),
			.horizontalEdges(padding: 16)
		)
		walletNameTextFieldView.pin(
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

	@objc
	private func navigateToRemoveAccountPage() {
		navigateToRemoveAccountPageClosure()
	}
}
