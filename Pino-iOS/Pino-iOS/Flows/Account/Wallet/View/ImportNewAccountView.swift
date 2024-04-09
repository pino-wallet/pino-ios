//
//  ImportNewAccountView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/3/24.
//

import Combine
import UIKit

class ImportNewAccountView: UIView {
	// MARK: - Private Properties

	private let contentStackView = UIStackView()
	private let accountInfoStackView = UIStackView()
	private let accountAvatarContainerView = UIView()
	private let accountAvatarStackView = UIStackView()
	private let avatarBackgroundView = UIView()
	private let accountAvatarImageView = UIImageView()
	private let setAvatarButton = UILabel()
	private let accountNameTextField = PinoTextFieldView(pattern: nil)
	private let importTextView = PrivateKeyTextView()
	private let importPrivateKeyStackView = UIStackView()
	private let privateKeyCardView = UIView()
	private let privateKeyPasteButton = UIButton()
	private let importTextViewDescription = UILabel()
	private let importButtonStackView = UIStackView()
	private let importButton = PinoButton(style: .deactive)
	private let pageDescriptionLabel = UILabel()
	private let importAccountVM: ImportNewAccountViewModel
	private var cancellables = Set<AnyCancellable>()

	private let importButtonDidTap: () -> Void
	private let changeAvatarDidTap: () -> Void

	// MARK: - Public Properties

	public var textViewText: String {
		importTextView.textViewText
	}

	// MARK: - Initializers

	init(
		importAccountVM: ImportNewAccountViewModel,
		importButtonDidTap: @escaping () -> Void,
		changeAvatarDidTap: @escaping () -> Void
	) {
		self.importAccountVM = importAccountVM
		self.importButtonDidTap = importButtonDidTap
		self.changeAvatarDidTap = changeAvatarDidTap
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		accountAvatarContainerView.addSubview(accountAvatarStackView)
		contentStackView.addArrangedSubview(accountInfoStackView)
		contentStackView.addArrangedSubview(importPrivateKeyStackView)
		accountInfoStackView.addArrangedSubview(accountAvatarContainerView)
		accountInfoStackView.addArrangedSubview(accountNameTextField)
		accountAvatarStackView.addArrangedSubview(avatarBackgroundView)
		accountAvatarStackView.addArrangedSubview(setAvatarButton)
		avatarBackgroundView.addSubview(accountAvatarImageView)
		importPrivateKeyStackView.addArrangedSubview(privateKeyCardView)
		importPrivateKeyStackView.addArrangedSubview(importTextViewDescription)
		privateKeyCardView.addSubview(importTextView)
		privateKeyCardView.addSubview(privateKeyPasteButton)
		importButtonStackView.addArrangedSubview(importButton)
		importButtonStackView.addArrangedSubview(pageDescriptionLabel)
		addSubview(contentStackView)
		addSubview(importButtonStackView)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))
		let setAccountAvatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(setNewAvatar))
		accountAvatarStackView.addGestureRecognizer(setAccountAvatarTapGesture)

		privateKeyPasteButton.addAction(UIAction(handler: { _ in
			self.importTextView.pasteText()
		}), for: .touchUpInside)

		importTextView.privateKeyDidChange = { privateKey in
			self.importAccountVM.validatePrivateKey(privateKey)
		}

		importButton.addAction(UIAction(handler: { _ in
			self.importButtonDidTap()
		}), for: .touchUpInside)

		accountNameTextField.textDidChange = {
			let accountName = self.accountNameTextField.getText() ?? .emptyString
			self.importAccountVM.accountName = accountName
			self.importAccountVM.validateAccountName(accountName)
		}
	}

	private func setupStyle() {
		setAvatarButton.text = importAccountVM.newAvatarButtonTitle
		accountNameTextField.text = importAccountVM.accountName
		accountNameTextField.placeholderText = importAccountVM.accountNamePlaceHolder
		importTextViewDescription.text = importAccountVM.textViewDescription
		pageDescriptionLabel.setFootnoteText(
			wholeString: importAccountVM.signDescriptionText, boldString: importAccountVM.signDescriptionBoldText
		)
		importButton.title = importAccountVM.continueButtonTitle
		privateKeyPasteButton.setTitle(importAccountVM.pasteButtonTitle, for: .normal)

		backgroundColor = .Pino.background
		privateKeyCardView.backgroundColor = .Pino.secondaryBackground

		setAvatarButton.textColor = .Pino.primary
		importTextViewDescription.textColor = .Pino.secondaryLabel
		privateKeyPasteButton.setTitleColor(.Pino.primary, for: .normal)

		setAvatarButton.font = .PinoStyle.mediumBody
		importTextViewDescription.font = .PinoStyle.mediumCaption1
		privateKeyPasteButton.titleLabel?.font = .PinoStyle.semiboldCallout

		contentStackView.axis = .horizontal
		accountInfoStackView.axis = .vertical
		accountAvatarStackView.axis = .vertical
		importPrivateKeyStackView.axis = .vertical
		contentStackView.axis = .vertical
		importButtonStackView.axis = .vertical

		contentStackView.spacing = 24
		accountInfoStackView.spacing = 32
		accountAvatarStackView.spacing = 8
		importPrivateKeyStackView.spacing = 8
		importButtonStackView.spacing = 12

		accountAvatarStackView.alignment = .center
		importPrivateKeyStackView.alignment = .leading
		importButtonStackView.alignment = .center

		avatarBackgroundView.layer.cornerRadius = 44
		privateKeyCardView.layer.cornerRadius = 8
		privateKeyCardView.layer.borderColor = UIColor.Pino.gray5.cgColor
		privateKeyCardView.layer.borderWidth = 1

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
		importTextView.pin(
			.top(padding: 12),
			.horizontalEdges(padding: 14)
		)
		privateKeyPasteButton.pin(
			.relative(.top, 8, to: importTextView, .bottom),
			.bottom(padding: 6),
			.trailing(padding: 8)
		)
		privateKeyCardView.pin(
			.fixedHeight(132),
			.width
		)
		importButtonStackView.pin(
			.bottom(to: layoutMarginsGuide, padding: 4),
			.horizontalEdges(padding: 16)
		)
		importButton.pin(
			.horizontalEdges
		)
		pageDescriptionLabel.pin(
			.horizontalEdges(padding: 8)
		)
	}

	private func setupBindings() {
		importAccountVM.$privateKeyValidationStatus.sink { validationStatus in
			self.updatePrivateKeyValidationState(validationStatus)
		}.store(in: &cancellables)

		importAccountVM.$accountNameValidationStatus.sink { validationStatus in
			self.updateAccountNameValidationStatus(validationStatus)
		}.store(in: &cancellables)

		importAccountVM.$accountAvatar.sink { accountAvatar in
			self.accountAvatarImageView.image = UIImage(named: accountAvatar.rawValue)
			self.avatarBackgroundView.backgroundColor = UIColor(named: accountAvatar.rawValue)
		}.store(in: &cancellables)
	}

	private func updatePrivateKeyValidationState(_ validationStatus: PrivateKeyValidationStatus) {
		switch validationStatus {
		case .isEmpty:
			importTextView.hideValidationView()
		case .isValid:
			importTextView.showSuccess()
		case .invalidKey:
			importTextView.showError()
		case .invalidAccount:
			break
		}
		activateImportButton(
			privateKeyValidationStatus: validationStatus,
			accountNameValidationStatus: importAccountVM.accountNameValidationStatus
		)
	}

	private func updateAccountNameValidationStatus(_ validationStatus: AccountNameValidationStatus) {
		switch validationStatus {
		case .isEmpty, .duplicateName:
			accountNameTextField.style = .error
		case .isValid:
			accountNameTextField.style = .normal
		}
		activateImportButton(
			privateKeyValidationStatus: importAccountVM.privateKeyValidationStatus,
			accountNameValidationStatus: validationStatus
		)
	}

	@objc
	private func setNewAvatar() {
		changeAvatarDidTap()
	}

	private func activateImportButton(
		privateKeyValidationStatus: PrivateKeyValidationStatus,
		accountNameValidationStatus: AccountNameValidationStatus
	) {
		if privateKeyValidationStatus == .isValid, accountNameValidationStatus == .isValid {
			importButton.style = .active
		} else {
			importButton.style = .deactive
		}
		updateImportButtonTitle(
			privateKeyValidationStatus: privateKeyValidationStatus,
			accountNameValidationStatus: accountNameValidationStatus
		)
	}

	private func updateImportButtonTitle(
		privateKeyValidationStatus: PrivateKeyValidationStatus,
		accountNameValidationStatus: AccountNameValidationStatus
	) {
		if privateKeyValidationStatus == .invalidKey {
			importButton.setTitle(importAccountVM.invalidPrivateKeyTitle, for: .normal)
		} else if accountNameValidationStatus == .duplicateName || accountNameValidationStatus == .isEmpty {
			importButton.setTitle(importAccountVM.invalidNameTitle, for: .normal)
		} else {
			importButton.setTitle(importAccountVM.continueButtonTitle, for: .normal)
		}
	}

	@objc
	private func dissmisskeyBoard() {
		importTextView.endEditing(true)
		accountNameTextField.endEditing(true)
	}

	// MARK: - Public Methods

	public func showLoading() {
		importButton.style = .loading
	}
}
