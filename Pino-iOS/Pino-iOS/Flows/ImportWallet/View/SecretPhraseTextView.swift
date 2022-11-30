//
//  SecretPhraseTextView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

class SecretPhraseTextView: UITextView {
	// MARK: Private Property

	private let suggestedSeedPhraseCollectionView = SuggestedSeedPhraseCollectionView()
	private var placeHolderText = "Secret Phrase"
	private let mockSeedPhraseList = MockSeedPhrase.wordList
	public var seedPhraseCountVerified: ((Bool) -> Void)?
	public var enteredWordsCount = UILabel()

	// MARK: Initializer

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

	#warning("These 3 functions are temporary and should be replaced by mnemonic generator functions")

	private func appendSelectedWordToTextView(_ selectedWord: String) {
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
				let filteredWords = mockSeedPhraseList.filter {
					$0.lowercased().hasPrefix(currentWord.lowercased())
				}
				suggestedSeedPhraseCollectionView.suggestedSeedPhrase = filteredWords
			}
		} else {
			suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		}
	}

	private func verifySeedPhrase() {
		var seedPhraseArray = text.components(separatedBy: " ")
		seedPhraseArray.removeAll(where: { $0.isEmpty })
		enteredWordsCount.text = "\(seedPhraseArray.count)/12"
		if let seedPhraseCountVerified {
			if seedPhraseArray.count == 12 {
				seedPhraseCountVerified(true)
			} else {
				seedPhraseCountVerified(false)
			}
		}
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
