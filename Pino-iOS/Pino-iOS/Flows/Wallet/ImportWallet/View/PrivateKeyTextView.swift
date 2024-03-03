//
//  SecretPhraseTextView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

class PrivateKeyTextView: UIView {
	// MARK: - Private Property

	private let privateKeyTextView = UITextView()
	private let validationStatusView = UIImageView()
	private var placeHolderText = "Private Key"
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var privateKeyDidChange: ((String) -> Void)!

	public var textViewText: String {
		privateKeyTextView.text
	}

	// MARK: - Initializer

	init() {
		super.init(frame: .zero)
		privateKeyTextView.delegate = self
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Public Method

	public func pasteText() {
		hideValidationView()
		let pasteboardString = UIPasteboard.general.string
		if let pasteboardString {
			privateKeyTextView.text = pasteboardString
			privateKeyTextView.textColor = .Pino.label
			privateKeyTextView.endEditing(true)
			privateKeyDidChange(pasteboardString)
		}
	}

	public func showError() {
		validationStatusView.image = UIImage(named: "error")
	}

	public func showSuccess() {
		validationStatusView.image = UIImage(named: "done")
	}

	public func hideValidationView() {
		validationStatusView.image = nil
	}

	// MARK: - Private Method

	private func setupView() {
		addSubview(privateKeyTextView)
		addSubview(validationStatusView)
	}

	private func setupStyle() {
		privateKeyTextView.autocorrectionType = .no
		privateKeyTextView.autocapitalizationType = .none
		privateKeyTextView.backgroundColor = .Pino.clear
		privateKeyTextView.text = placeHolderText
		privateKeyTextView.textColor = .Pino.gray2
		privateKeyTextView.font = .PinoStyle.mediumBody
		privateKeyTextView.returnKeyType = .done
	}

	private func setupConstraint() {
		privateKeyTextView.pin(
			.verticalEdges,
			.trailing(padding: 50),
			.leading
		)
		validationStatusView.pin(
			.fixedWidth(24),
			.fixedHeight(24),
			.trailing,
			.top
		)
	}
}

extension PrivateKeyTextView: UITextViewDelegate {
	// MARK: - Text View Delegate Method

	internal func textViewDidBeginEditing(_ textView: UITextView) {
		if privateKeyTextView.text == placeHolderText {
			privateKeyTextView.text = nil
			privateKeyTextView.textColor = .Pino.label
		}
		becomeFirstResponder()
	}

	internal func textViewDidEndEditing(_ textView: UITextView) {
		if privateKeyTextView.text.isEmpty {
			privateKeyTextView.text = placeHolderText
			privateKeyTextView.textColor = .Pino.gray2
		}
		resignFirstResponder()
	}

	internal func textViewDidChange(_ textView: UITextView) {
		privateKeyDidChange(privateKeyTextView.text)
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		} else {
			return true
		}
	}
}
