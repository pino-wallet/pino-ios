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

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let pageTitle = UILabel()
	private let pageDescription = UILabel()
	private let collectionsStackView = UIStackView()
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

		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}
}

extension VerifySecretPhraseView {
	// MARK: Secret Phrase Methods

	private func selectSeedPhraseCell(_ selectedWord: String) {
		updateSecretPhraseCell(to: .empty, selectedWord: selectedWord)
		addSelectedWordToSortedPhrase(selectedWord)
		checkSecretPhraseSequence()
	}

	private func deselectSeedPhraseCell(_ selectedWord: String) {
		updateSecretPhraseCell(to: .unordered, selectedWord: selectedWord)
		removeSelectedWordFromSortedPhrase(selectedWord)
		checkSecretPhraseSequence()
	}

	private func updateSecretPhraseCell(to style: SecretPhraseCell.Style, selectedWord: String) {
		guard let index = randomPhrase.firstIndex(of: selectedWord) else { return }
		let indexPath = IndexPath(row: index, section: 0)
		let cell = randomPhraseCollectionView.cellForItem(at: indexPath) as! SecretPhraseCell
		switch style {
		case .regular:
			cell.seedPhrase = DefaultSeedPhrase(sequence: index, title: selectedWord)
		case .unordered:
			cell.seedPhrase = UnorderedSeedPhrase(title: selectedWord)
		case .empty:
			cell.seedPhrase = EmptySeedPhrase()
		}
	}

	private func addSelectedWordToSortedPhrase(_ selectedWord: String) {
		sortedPhraseCollectionView.secretWords.append(selectedWord)
	}

	private func removeSelectedWordFromSortedPhrase(_ selectedWord: String) {
		sortedPhraseCollectionView.secretWords.removeAll(where: { $0 == selectedWord })
	}

	private func checkSecretPhraseSequence() {
		let sortedWords = sortedPhraseCollectionView.secretWords

		switch sortedWords {
		// All words are selected in the correct order
		case userSecretPhrase:
			errorStackView.isHidden = true
			continueButton.style = .active
		// Some words are selected in the correct order
		case Array(userSecretPhrase.prefix(upTo: sortedWords.count)):
			errorStackView.isHidden = true
			continueButton.style = .deactive
		// The words are NOT selected in the correct order
		default:
			errorStackView.isHidden = false
			continueButton.style = .deactive
		}
	}
}

extension VerifySecretPhraseView {
	// MARK: UI Methods

	private func setupView() {
		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(collectionsStackView)
		collectionsStackView.addArrangedSubview(sortedPhraseBoxView)
		collectionsStackView.addArrangedSubview(randomPhraseCollectionView)
		titleStackView.addArrangedSubview(pageTitle)
		titleStackView.addArrangedSubview(pageDescription)
		errorStackView.addArrangedSubview(errorIcon)
		errorStackView.addArrangedSubview(errorLabel)
		sortedPhraseBoxView.addSubview(sortedPhraseCollectionView)
		sortedPhraseBoxView.addSubview(errorStackView)
		contentView.addSubview(contentStackView)
		scrollView.addSubview(contentView)
		addSubview(scrollView)
		addSubview(continueButton)

		continueButton.addAction(UIAction(handler: { _ in
			if self.continueButton.style == .active {
				self.createWallet(self.sortedPhraseCollectionView.secretWords)
			}
		}), for: .touchUpInside)

		randomPhraseCollectionView.wordSelected = { secretPhraseword in
			self.selectSeedPhraseCell(secretPhraseword)
		}
		sortedPhraseCollectionView.wordSelected = { secretPhraseword in
			self.deselectSeedPhraseCell(secretPhraseword)
		}
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground

		randomPhraseCollectionView.secretWords = randomPhrase
		randomPhraseCollectionView.cellStyle = .unordered
		sortedPhraseCollectionView.secretWords = []

		pageTitle.text = "Verify seed pharase"
		pageTitle.textColor = .Pino.label
		pageTitle.font = .PinoStyle.semiboldTitle3

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
		contentStackView.spacing = 36

		collectionsStackView.axis = .vertical
		collectionsStackView.spacing = 18

		titleStackView.axis = .vertical
		titleStackView.spacing = 16

		errorStackView.axis = .horizontal
		errorStackView.spacing = 5
		errorStackView.alignment = .center

		sortedPhraseBoxView.backgroundColor = .Pino.background
	}

	private func setupContstraint() {
		scrollView.pin(
			.top(to: layoutMarginsGuide),
			.relative(.bottom, 0, to: continueButton, .top),
			.horizontalEdges
		)
		contentView.pin(
			.allEdges,
			.width(to: self)
		)
		contentStackView.pin(
			.horizontalEdges,
			.verticalEdges(padding: 24)
		)
		collectionsStackView.pin(
			.horizontalEdges
		)
		titleStackView.pin(
			.horizontalEdges(padding: 16)
		)
		continueButton.pin(
			.bottom(padding: 42),
			.horizontalEdges(padding: 16),
			.fixedHeight(56)
		)
		sortedPhraseBoxView.pin(
			.horizontalEdges,
			.height(to: randomPhraseCollectionView, padding: 102)
		)
		sortedPhraseCollectionView.pin(
			.horizontalEdges(padding: 16),
			.top(padding: 16)
		)
		errorStackView.pin(
			.bottom(to: sortedPhraseBoxView, padding: 16),
			.centerX
		)
		errorIcon.pin(
			.fixedWidth(16),
			.fixedHeight(16)
		)
		errorLabel.pin(
			.fixedHeight(24)
		)
		randomPhraseCollectionView.pin(
			.horizontalEdges(padding: 16)
		)
	}
}
