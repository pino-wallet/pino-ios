//
//  VerifySecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//
// swiftlint: disable force_cast

import UIKit

class VerifySecretPhraseView: UIView {
	// MARK: Private Properties

	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let pageTitle = UILabel()
	private let pageDescription = UILabel()
	private let sortedPhraseBoxView = UIView()
	private let sortedPhraseCollectionView = SecretPhraseCollectionView()
	private let errorStackView = UIStackView()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private let randomPhraseCollectionView = SecretPhraseCollectionView()
	private let continueButton = PinoButton(style: .deactive, title: "Continue")
	private var createWallet: ([String]) -> Void
	private var userSecretPhrase: [String]
	private var randomPhrase: [String]

	// MARK: Initializers

	init(_ secretPhrase: [String], createWallet: @escaping (([String]) -> Void)) {
		self.createWallet = createWallet
		self.userSecretPhrase = secretPhrase
		self.randomPhrase = secretPhrase.shuffled()
		super.init(frame: .zero)
		randomPhraseCollectionView.words = randomPhrase
		randomPhraseCollectionView.cellStyle = .unordered
		sortedPhraseCollectionView.words = []
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	private func activateContinueButton(_ isActive: Bool) {
		if isActive {
			continueButton.style = .active
		} else {
			continueButton.style = .deactive
		}
	}
}

extension VerifySecretPhraseView {
	// MARK: Secret Phrase Methods

	func selectSeedPhraseCell(_ selectedWord: String) {
		let emptyCell = EmptySeedPhrase()
		updateSecretPhraseCell(to: emptyCell, selectedWord: selectedWord) { isSelectable in
			if isSelectable {
				addSelectedWordToSortedPhrase(selectedWord)
				checkSecretPhraseSequence()
			}
		}
	}

	func deselectSeedPhraseCell(_ selectedWord: String) {
		let unorderedCell = UnorderedSeedPhrase(title: selectedWord)
		updateSecretPhraseCell(to: unorderedCell, selectedWord: selectedWord) { isSelectable in
			if isSelectable {
				removeSelectedWordFromSortedPhrase(selectedWord)
				checkSecretPhraseSequence()
			}
		}
	}

	private func updateSecretPhraseCell(to seedPhrase: SeedPhrase, selectedWord: String, isSelectable: (Bool) -> Void) {
		guard let index = randomPhrase.firstIndex(of: selectedWord) else { return }
		let indexPath = IndexPath(row: index, section: 0)
		let cell = randomPhraseCollectionView.cellForItem(at: indexPath) as! SecretPhraseCell
		isSelectable(cell.seedPhrase.title != seedPhrase.title)
		cell.seedPhrase = seedPhrase
	}

	private func addSelectedWordToSortedPhrase(_ selectedWord: String) {
		sortedPhraseCollectionView.words.append(selectedWord)
	}

	private func removeSelectedWordFromSortedPhrase(_ selectedWord: String) {
		sortedPhraseCollectionView.words.removeAll(where: { $0 == selectedWord })
	}

	private func checkSecretPhraseSequence() {
		let sortedWords = sortedPhraseCollectionView.words

		switch sortedWords {
		// All words are selected in the correctorder
		case userSecretPhrase:
			errorStackView.isHidden = true
			activateContinueButton(true)
		// Some words are selected in the correct order
		case Array(userSecretPhrase.prefix(upTo: sortedWords.count)):
			errorStackView.isHidden = true
			activateContinueButton(false)
		// The words are NOT selected in the correct order
		default:
			errorStackView.isHidden = false
			activateContinueButton(false)
		}
	}
}

extension VerifySecretPhraseView {
	// MARK: UI Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(sortedPhraseBoxView)
		contentStackView.addArrangedSubview(randomPhraseCollectionView)
		titleStackView.addArrangedSubview(pageTitle)
		titleStackView.addArrangedSubview(pageDescription)
		errorStackView.addArrangedSubview(errorIcon)
		errorStackView.addArrangedSubview(errorLabel)
		sortedPhraseBoxView.addSubview(sortedPhraseCollectionView)
		sortedPhraseBoxView.addSubview(errorStackView)
		addSubview(contentStackView)
		addSubview(continueButton)

		continueButton.addAction(UIAction(handler: { _ in
			if self.continueButton.style == .active {
				self.createWallet(self.sortedPhraseCollectionView.words)
			}
		}), for: .touchUpInside)

		randomPhraseCollectionView.wordSelected = { word in
			self.selectSeedPhraseCell(word)
		}
		sortedPhraseCollectionView.wordSelected = { word in
			self.deselectSeedPhraseCell(word)
		}
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		pageTitle.text = "Verify seed pharase"
		pageTitle.textColor = .Pino.label
		pageTitle.font = .PinoStyle.semiboldTitle2

		pageDescription.text = "A two line description should be here. A two line description should be here"
		pageDescription.textColor = .Pino.secondaryLabel
		pageDescription.font = .PinoStyle.mediumCallout
		pageDescription.numberOfLines = 0

		errorLabel.text = "Invalid order! Try again"
		errorLabel.textColor = .Pino.ErrorRed
		errorLabel.font = .PinoStyle.mediumCallout
		errorLabel.textAlignment = .center
		errorStackView.isHidden = true

		errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorIcon.tintColor = .Pino.ErrorRed

		contentStackView.axis = .vertical
		contentStackView.spacing = 32

		titleStackView.axis = .vertical
		titleStackView.spacing = 12

		errorStackView.axis = .horizontal
		errorStackView.spacing = 5
		errorStackView.alignment = .center

		sortedPhraseBoxView.backgroundColor = .Pino.background
	}

	private func setupContstraint() {
		contentStackView.pin(.top(padding: 115), .horizontalEdges)
		titleStackView.pin(.horizontalEdges(padding: 16))
		continueButton.pin(.bottom(padding: 42), .horizontalEdges(padding: 16), .fixedHeight(56))
		sortedPhraseBoxView.pin(.horizontalEdges, .height(to: randomPhraseCollectionView, padding: 100))
		sortedPhraseCollectionView.pin(.horizontalEdges(padding: 16), .top(padding: 16))
		errorStackView.pin(.bottom(to: sortedPhraseBoxView, padding: 16), .centerX)
		errorIcon.pin(.fixedWidth(16), .fixedHeight(16))
		errorLabel.pin(.fixedHeight(24))
		randomPhraseCollectionView.pin(.horizontalEdges(padding: 16))
	}
}
