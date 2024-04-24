//
//  CreateNewAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/20/24.
//

import Combine
import UIKit

class CreateNewAccountView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let accountInfoStackView = UIStackView()
	private let accountAvatarContainerView = UIView()
	private let accountAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let accountAvatarImageView = UIImageView()
	private let setAvatarButton = UILabel()
	private let accountNameTextField = PinoTextFieldView(pattern: nil)
	private let createButtonStackView = UIStackView()
	private let createButton = PinoButton(style: .deactive)
	private let pageDescriptionLabel = UILabel()
	private let hapticManager = HapticManager()
	private var cancellables = Set<AnyCancellable>()

	private let avatarButtonDidTap: () -> Void
	private let createButtonDidTap: () -> Void
	private let createAccountVM: CreateNewAccountViewModel

	// MARK: - Initializers

	init(
		createAccountVM: CreateNewAccountViewModel,
		avatarButtonDidTap: @escaping () -> Void,
		createButtonDidTap: @escaping () -> Void
	) {
		self.createAccountVM = createAccountVM
		self.avatarButtonDidTap = avatarButtonDidTap
		self.createButtonDidTap = createButtonDidTap
		super.init(frame: .zero)

		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		accountAvatarContainerView.addSubview(accountAvatarStackView)
		contentStackView.addArrangedSubview(accountInfoStackView)
		accountInfoStackView.addArrangedSubview(accountAvatarContainerView)
		accountInfoStackView.addArrangedSubview(accountNameTextField)
		accountAvatarStackView.addArrangedSubview(avatarBackgroundView)
		accountAvatarStackView.addArrangedSubview(setAvatarButton)
		avatarBackgroundView.addSubview(accountAvatarImageView)
		createButtonStackView.addArrangedSubview(createButton)
		createButtonStackView.addArrangedSubview(pageDescriptionLabel)
		addSubview(contentStackView)
		addSubview(createButtonStackView)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
		let setAccountAvatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(setNewAvatar))
		accountAvatarStackView.addGestureRecognizer(setAccountAvatarTapGesture)

		createButton.addAction(UIAction(handler: { _ in
			self.hapticManager.run(type: .mediumImpact)
			self.createButtonDidTap()
		}), for: .touchUpInside)

		accountNameTextField.textDidChange = {
			let accountName = self.accountNameTextField.getText() ?? .emptyString
			self.createAccountVM.accountName = accountName
			self.createAccountVM.validateAccountName(accountName)
		}
	}

	private func setupStyle() {
		setAvatarButton.text = createAccountVM.newAvatarButtonTitle
		accountNameTextField.text = createAccountVM.accountName
		accountNameTextField.placeholderText = createAccountVM.accountNamePlaceHolder
		pageDescriptionLabel.setFootnoteText(
			wholeString: createAccountVM.signDescriptionText, boldString: createAccountVM.signDescriptionBoldText
		)
		createButton.title = createAccountVM.createButtonTitle

		backgroundColor = .Pino.background

		setAvatarButton.textColor = .Pino.primary

		setAvatarButton.font = .PinoStyle.mediumBody

		contentStackView.axis = .horizontal
		accountInfoStackView.axis = .vertical
		accountAvatarStackView.axis = .vertical
		contentStackView.axis = .vertical
		createButtonStackView.axis = .vertical

		contentStackView.spacing = 24
		accountInfoStackView.spacing = 32
		accountAvatarStackView.spacing = 8
		createButtonStackView.spacing = 12

		accountAvatarStackView.alignment = .center
		createButtonStackView.alignment = .center

		avatarBackgroundView.layer.cornerRadius = 44

		accountNameTextField.textFieldKeyboardOnReturn = {
			self.endEditing(true)
		}
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 26),
			.horizontalEdges(padding: 16)
		)
		accountAvatarStackView.pin(
			.fixedWidth(176),
			.verticalEdges,
			.centerX
		)
		avatarBackgroundView.pin(
			.fixedHeight(88),
			.fixedWidth(88)
		)
		accountAvatarImageView.pin(
			.allEdges(padding: 19)
		)
		createButtonStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 4),
			.horizontalEdges(padding: 16)
		)
		createButton.pin(
			.horizontalEdges
		)
		pageDescriptionLabel.pin(
			.horizontalEdges(padding: 8)
		)
	}

	private func setupBindings() {
		createAccountVM.$accountNameValidationStatus.sink { validationStatus in
			self.updateAccountNameValidationStatus(validationStatus)
		}.store(in: &cancellables)

		createAccountVM.$accountAvatar.sink { accountAvatar in
			self.accountAvatarImageView.image = UIImage(named: accountAvatar.rawValue)
			self.avatarBackgroundView.backgroundColor = UIColor(named: accountAvatar.rawValue)
		}.store(in: &cancellables)
	}

	private func updateAccountNameValidationStatus(_ validationStatus: AccountNameValidationStatus) {
		switch validationStatus {
		case .isEmpty:
			accountNameTextField.style = .error
			createButton.style = .deactive
			createButton.setTitle(ImportWalletError.emptyAccountName.btnErrorTxt, for: .normal)
		case .duplicateName:
			accountNameTextField.style = .error
			createButton.style = .deactive
			createButton.setTitle(ImportWalletError.duplicateAccountName.btnErrorTxt, for: .normal)
		case .isValid:
			accountNameTextField.style = .normal
			createButton.style = .active
			createButton.setTitle(createAccountVM.createButtonTitle, for: .normal)
		}
	}

	@objc
	private func setNewAvatar() {
		hapticManager.run(type: .mediumImpact)
		avatarButtonDidTap()
	}

	@objc
	private func dissmisskeyBoard() {
		accountNameTextField.endEditing(true)
	}

	// MARK: - Public Methods

	public func showLoading() {
		createButton.style = .loading
	}
}
