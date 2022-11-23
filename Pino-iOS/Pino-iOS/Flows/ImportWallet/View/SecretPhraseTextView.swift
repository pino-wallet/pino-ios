//
//  SecretPhraseTextView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//

import UIKit

class SecretPhraseTextView: UITextView {
	private let suggestedSeedPhraseCollectionView = SuggestedSeedPhraseCollectionView()
	private var placeHolderText = "Seed Phrase"

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: .zero, textContainer: textContainer)
		delegate = self
		setupStyle()
		setupSuggestedSeedPhrase()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupStyle() {
		text = placeHolderText
		textColor = .Pino.gray2
		font = .PinoStyle.mediumBody
	}

	private func setupSuggestedSeedPhrase() {
		suggestedSeedPhraseCollectionView.suggestedSeedPhrase = []
		inputAccessoryView = suggestedSeedPhraseCollectionView
	}

	public func pasteText() {
		let pasteboardString = UIPasteboard.general.string
		if let pasteboardString {
			text = pasteboardString
			textColor = .Pino.label
			endEditing(true)
		}
	}
}

extension SecretPhraseTextView: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if text == placeHolderText {
			text = nil
			textColor = .Pino.label
		}
		becomeFirstResponder()
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if text.isEmpty {
			text = placeHolderText
			textColor = .Pino.gray2
		}
		resignFirstResponder()
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		filterSeedPhrase(textViewNSString: textView.text as NSString, textRange: range, replacementText: text)
		return true
	}

	func filterSeedPhrase(textViewNSString: NSString?, textRange: NSRange, replacementText: String) {
		let seedPhraseArray = textViewNSString?.replacingCharacters(
			in: textRange,
			with: replacementText
		).components(
			separatedBy: " "
		)
		if let currentWord = seedPhraseArray?.last {
			let filteredWords = MockSeedPhrase.wordList.filter {
				$0.lowercased().hasPrefix(currentWord.lowercased())
			}
			suggestedSeedPhraseCollectionView.suggestedSeedPhrase = filteredWords
		}
	}
}
