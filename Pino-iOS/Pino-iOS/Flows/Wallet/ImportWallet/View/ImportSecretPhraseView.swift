//
//  ImportSecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseView: UIView {
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
	private var validationPhraseVM: ImportAccountViewModel
    private let importButton = PinoButton(style: .deactive)


	// MARK: - Public Properties

	public let errorStackView = UIStackView()
	public let importTextView: ImportTextViewType!
	public var textViewText: String {
		importTextView.text
	}
    public let importBtnTapped: ()->Void

	// MARK: - Initializers

    init(validationPharaseVM: ImportAccountViewModel, textViewType: ImportTextViewType, importBtnTapped: @escaping ()->Void) {
		self.validationPhraseVM = validationPharaseVM
		self.importTextView = textViewType
		if let seedPhraseTextView = importTextView as? SecretPhraseTextView {
			seedPhraseTextView.seedPhraseMaxCount = validationPharaseVM.maxSeedPhraseCount
		}
        self.importBtnTapped = importBtnTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension ImportSecretPhraseView {
	// MARK: UI Methods

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
            self.importButton.style = .loading
            self.importBtnTapped()
        }), for: .touchUpInside)
	}

	public func showError() {
		importTextView.errorStackView.isHidden = false
	}

	private func setupStyle() {
		titleLabel.text = validationPhraseVM.title
		descriptionLabel.text = validationPhraseVM.description
		errorLabel.text = validationPhraseVM.errorTitle
		errorIcon.image = UIImage(systemName: validationPhraseVM.errorIcon)
		importButton.title = validationPhraseVM.continueButtonTitle
		seedPhrasePasteButton.setTitle(validationPhraseVM.pasteButtonTitle, for: .normal)

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

	@objc
	private func dissmisskeyBoard() {
		importTextView.endEditing(true)
	}
}
