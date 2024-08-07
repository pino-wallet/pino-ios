//
//  SecretPhraseTextView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

class SecretPhraseTextView: UITextView, ImportTextViewType {
	// MARK: - Private Property

	private let suggestedSeedPhraseCollectionView = SuggestedSeedPhraseCollectionView()
	private var placeHolderText = "Secret Phrase"

	// MARK: - Public Properties

	public var errorStackView = UIStackView()
	public var seedPhraseArray: [String] = []
	public var importKeyCountVerified: ((Bool) -> Void)?
	public var seedPhraseMaxCount: Int!
	public var enteredWordsCount = UILabel()

	// MARK: - Initializer

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: .zero, textContainer: textContainer)
		delegate = self
		setupStyle()
		setupSuggestedSeedPhrase()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: Public Method

	public func pasteText() {
		hideError()
		let pasteboardString = UIPasteboard.general.string
		if let pasteboardString {
			text = pasteboardString
			textColor = .Pino.label
			endEditing(true)
			verifySeedPhrase()
		}
	}

	// MARK: Private Method

	private func setupStyle() {
		autocorrectionType = .no
		autocapitalizationType = .none
		backgroundColor = .Pino.clear
		text = placeHolderText
		textColor = .Pino.gray2
		font = .PinoStyle.mediumBody
		returnKeyType = UIReturnKeyType.done

		enteredWordsCount.text = "0/12"
		enteredWordsCount.textColor = .Pino.secondaryLabel
		enteredWordsCount.font = .PinoStyle.mediumFootnote
	}

	private func setupSuggestedSeedPhrase() {
		suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		suggestedSeedPhraseCollectionView.seedPhraseDidSelect = { selectedWord in
			self.appendSelectedWordToTextView(selectedWord)
		}
		inputAccessoryView = suggestedSeedPhraseCollectionView
	}

	private func appendSelectedWordToTextView(_ selectedWord: String) {
		hideError()
		var seedPhraseArray = text.components(separatedBy: " ")
		seedPhraseArray.removeLast()
		seedPhraseArray.append("\(selectedWord) ")
		text = seedPhraseArray.joined(separator: " ")
		verifySeedPhrase()
	}

	private func filterSeedPhrase(textViewString: String) {
		// Suggest word only when the cursor is at the end of the phrase
		if let selectedTextRange, selectedTextRange.end == endOfDocument {
			let seedPhraseArray = textViewString.components(separatedBy: " ")
			if let currentWord = seedPhraseArray.last {
				let fiteredWords = HDWallet.getSuggestions(forWord: currentWord.lowercased())
				suggestedSeedPhraseCollectionView.suggestedSeedPhrase = fiteredWords
			}
		} else {
			suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		}
	}

	private func verifySeedPhrase() {
		if let importKeyCountVerified {
			seedPhraseArray = text.components(separatedBy: " ")
			seedPhraseArray.removeAll(where: { $0.isEmpty })
			enteredWordsCount.text = "\(seedPhraseArray.count)/12"
			if seedPhraseArray.count == seedPhraseMaxCount {
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

extension SecretPhraseTextView: UITextViewDelegate {
	// MARK: Text View Delegate Method

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
		filterSeedPhrase(textViewString: textView.text)
		verifySeedPhrase()
	}

	internal func textViewDidChangeSelection(_ textView: UITextView) {
		// Don't suggest word when the curser is not at the end of the phrase
		if let selectedTextRange, selectedTextRange.end != endOfDocument {
			suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		}
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
