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
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let seedPhraseStackView = UIStackView()
	private let seedPhraseBox = UIView()
	private let seedPhrasePasteButton = UIButton()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private var importAccountVM: ImportNewAccountViewModel
	private let importButton = PinoButton(style: .deactive)
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let errorStackView = UIStackView()
	public let importTextView: ImportTextViewType!
	public var textViewText: String {
		importTextView.text
	}

	public let importBtnTapped: () -> Void

	// MARK: - Initializers

	init(
		importAccountVM: ImportNewAccountViewModel,
		textViewType: ImportTextViewType,
		importBtnTapped: @escaping () -> Void
	) {
		self.importAccountVM = importAccountVM
		self.importTextView = textViewType
		self.importBtnTapped = importBtnTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(seedPhraseStackView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		seedPhraseStackView.addArrangedSubview(seedPhraseBox)
		seedPhraseStackView.addArrangedSubview(importTextView.errorStackView)
		seedPhraseBox.addSubview(importTextView)
		seedPhraseBox.addSubview(seedPhrasePasteButton)
		importTextView.errorStackView.addArrangedSubview(errorIcon)
		importTextView.errorStackView.addArrangedSubview(errorLabel)
		addSubview(contentStackView)
		addSubview(importButton)
		addSubview(importTextView.enteredWordsCount)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmisskeyBoard)))

		seedPhrasePasteButton.addAction(UIAction(handler: { _ in
			self.importTextView.pasteText()
		}), for: .touchUpInside)

		importTextView.importKeyCountVerified = { isVerified in
			if isVerified {
				self.importButton.style = .active
			} else {
				self.importButton.style = .deactive
			}
		}

		importButton.addAction(UIAction(handler: { _ in
			self.importBtnTapped()
		}), for: .touchUpInside)
	}

	// MARK: - Public Methods

	public func showError() {
		importTextView.errorStackView.isHidden = false
	}

	public func activateButton() {
		importButton.style = .active
	}

	// MARK: - Private Methods

	private func setupStyle() {
		descriptionLabel.text = importAccountVM.pageDeescription
		importButton.title = importAccountVM.continueButtonTitle
		seedPhrasePasteButton.setTitle(importAccountVM.pasteButtonTitle, for: .normal)

		backgroundColor = .Pino.secondaryBackground

		errorLabel.textColor = .Pino.errorRed
		errorIcon.tintColor = .Pino.errorRed
		seedPhrasePasteButton.setTitleColor(.Pino.primary, for: .normal)

		errorLabel.font = .PinoStyle.mediumCallout
		seedPhrasePasteButton.titleLabel?.font = .PinoStyle.semiboldCallout

		contentStackView.axis = .horizontal
		seedPhraseStackView.axis = .vertical
		contentStackView.axis = .vertical
		titleStackView.axis = .vertical

		importTextView.errorStackView.spacing = 5
		seedPhraseStackView.spacing = 8
		contentStackView.spacing = 33
		titleStackView.spacing = 18

		seedPhraseStackView.alignment = .leading
		errorLabel.textAlignment = .center

		seedPhraseBox.layer.cornerRadius = 8
		seedPhraseBox.layer.borderColor = UIColor.Pino.gray5.cgColor
		seedPhraseBox.layer.borderWidth = 1

		importTextView.errorStackView.isHidden = true
	}

	private func setupContstraint() {
		contentStackView.pin(
			.top(to: layoutMarginsGuide, padding: 26),
			.horizontalEdges(padding: 16)
		)
		importTextView.pin(
			.top(padding: 12),
			.horizontalEdges(padding: 12)
		)
		seedPhrasePasteButton.pin(
			.relative(.top, 8, to: importTextView, .bottom),
			.bottom(padding: 6),
			.trailing(padding: 8)
		)
		seedPhraseBox.pin(
			.fixedHeight(160),
			.width
		)
		errorIcon.pin(
			.fixedWidth(16),
			.fixedHeight(16)
		)
		errorLabel.pin(
			.fixedHeight(24)
		)
		importButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		importTextView.enteredWordsCount.pin(
			.relative(.top, 10, to: seedPhraseBox, .bottom),
			.trailing(padding: 17)
		)
	}

	private func setupBindings() {
		importAccountVM.$validationStatus.sink { validationStatus in
			switch validationStatus {
			case .normal:
				self.importButton.setTitle(self.importAccountVM.continueButtonTitle, for: .normal)
				self.importButton.style = .deactive
			case .loading:
				self.importButton.setTitle(self.importAccountVM.continueButtonTitle, for: .normal)
				self.importButton.style = .deactive
			case .error:
				self.importButton.setTitle(self.importAccountVM.InvalidTitle, for: .normal)
				self.importButton.style = .deactive
			case .success:
				self.importButton.setTitle(self.importAccountVM.continueButtonTitle, for: .normal)
				self.importButton.style = .active
			}
		}.store(in: &cancellables)
	}

	@objc
	private func dissmisskeyBoard() {
		importTextView.endEditing(true)
	}
}
