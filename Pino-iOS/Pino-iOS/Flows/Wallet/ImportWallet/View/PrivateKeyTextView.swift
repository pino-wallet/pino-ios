//
//  SecretPhraseTextView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

class PrivateKeyTextView: UITextView, ImportTextViewType {
	// MARK: - Private Property

	private var placeHolderText = "Private Key"
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Public Properties

	public var errorStackView = UIStackView()
	public var importKeyCountVerified: ((Bool) -> Void)?
	public var enteredWordsCount = UILabel()

	// MARK: - Initializer

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: .zero, textContainer: textContainer)
		delegate = self
		setupStyle()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Public Method

	public func pasteText() {
		hideError()
		let pasteboardString = UIPasteboard.general.string
		if let pasteboardString {
			text = pasteboardString
			textColor = .Pino.label
			endEditing(true)
			verifyPrivateKey()
		}
	}

	// MARK: - Private Method

	private func setupStyle() {
		autocorrectionType = .no
		autocapitalizationType = .none
		backgroundColor = .Pino.clear
		text = placeHolderText
		textColor = .Pino.gray2
		font = .PinoStyle.mediumBody
		returnKeyType = UIReturnKeyType.done

		enteredWordsCount.text = "0/64"
		enteredWordsCount.textColor = .Pino.secondaryLabel
		enteredWordsCount.font = .PinoStyle.mediumFootnote
	}

	private func verifyPrivateKey() {
		if let importKeyCountVerified {
			enteredWordsCount.text = "\(text.count)/64"
			if pinoWalletManager.isPrivatekeyValid(text) {
				importKeyCountVerified(true)
			} else {
				importKeyCountVerified(false)
			}
		}
	}

	private func hideError() {
		errorStackView.isHidden = true
	}
}

extension PrivateKeyTextView: UITextViewDelegate {
	// MARK: - Text View Delegate Method

	internal func textViewDidBeginEditing(_ textView: UITextView) {
		if text == placeHolderText {
			text = nil
			textColor = .Pino.label
		}
		becomeFirstResponder()
	}

	internal func textViewDidEndEditing(_ textView: UITextView) {
		if text.isEmpty {
			text = placeHolderText
			textColor = .Pino.gray2
		}
		resignFirstResponder()
	}

	internal func textViewDidChange(_ textView: UITextView) {
		hideError()
		verifyPrivateKey()
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
