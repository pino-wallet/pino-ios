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
	private var createWallet: ([SeedPhrase]) -> Void
	private var userSecretPhrase: [SeedPhrase]
	private var randomPhrase: [SeedPhrase]
	private var sortedPhrase: [SeedPhrase] = []

	// MARK: Initializers

	init(_ secretPhrase: [SeedPhrase], createWallet: @escaping (([SeedPhrase]) -> Void)) {
		self.createWallet = createWallet
		self.userSecretPhrase = secretPhrase
		self.randomPhrase = secretPhrase.shuffled()
		super.init(frame: .zero)
		randomPhraseCollectionView.seedPhrase = randomPhrase
		sortedPhraseCollectionView.seedPhrase = []
		randomPhraseCollectionView.defultStyle = .noSequence
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

		#warning("This code should be uncommented before push")
		continueButton.addAction(UIAction(handler: { _ in
//			if self.continueButton.style == .active {
			self.createWallet(self.sortedPhrase)
//			}
		}), for: .touchUpInside)

		randomPhraseCollectionView.wordSelected = { seedPhrase in
			self.selectWord(seedPhrase)
		}
		sortedPhraseCollectionView.wordSelected = { seedPhrase in
			self.deselectWord(seedPhrase)
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
		errorLabel.textColor = .Pino.errorRed
		errorLabel.font = .PinoStyle.mediumCallout
		errorLabel.textAlignment = .center
		errorStackView.isHidden = true

		errorIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
		errorIcon.tintColor = .Pino.errorRed

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

extension VerifySecretPhraseView {
	// MARK: Secret Phrase Methods

	func selectWord(_ seedPhrase: SeedPhrase) {
		guard let index = randomPhrase.firstIndex(of: seedPhrase) else { return }
		updateSecretPhraseCell(at: index, style: .empty) { emptyStyle in
			if !emptyStyle {
				addWordToSortedPhrase(seedPhrase)
				self.checkPhraseSequence()
			}
		}
	}

	func deselectWord(_ seedPhrase: SeedPhrase) {
		guard let index = randomPhrase.firstIndex(where: { $0.title == seedPhrase.title }) else { return }
		updateSecretPhraseCell(at: index, style: .noSequence) { emptyStyle in
			if emptyStyle {
				removeWordFromSortedPhrase(seedPhrase)
				self.checkPhraseSequence()
			}
		}
	}

	private func updateSecretPhraseCell(
		at index: Int,
		style: SecretPhraseCell.SeedPhraseStyle,
		emptyStyle: (Bool) -> Void
	) {
		let indexPath = IndexPath(row: index, section: 0)
		let cell = randomPhraseCollectionView.cellForItem(at: indexPath) as! SecretPhraseCell
		emptyStyle(cell.seedPhraseStyle == .empty)
		cell.seedPhraseStyle = style
	}

	private func addWordToSortedPhrase(_ word: SeedPhrase) {
		let selectedWord = SeedPhrase(title: word.title, sequence: sortedPhrase.count + 1)
		sortedPhrase.append(selectedWord)
		sortedPhraseCollectionView.seedPhrase = sortedPhrase
	}

	private func removeWordFromSortedPhrase(_ word: SeedPhrase) {
		if sortedPhrase.last == word {
			sortedPhrase.removeLast()
		} else {
			sortedPhrase.removeAll(where: { $0 == word })
			updateSortedPhraseSequence()
		}
		sortedPhraseCollectionView.seedPhrase = sortedPhrase
	}

	private func updateSortedPhraseSequence() {
		for index in 0 ..< sortedPhrase.count {
			let word = sortedPhrase[index].title
			let sequence = index + 1
			sortedPhrase[index] = SeedPhrase(title: word, sequence: sequence)
		}
	}

	private func checkPhraseSequence() {
		switch sortedPhrase {
		case userSecretPhrase:
			errorStackView.isHidden = true
			activateContinueButton(true)
		case Array(userSecretPhrase.prefix(upTo: sortedPhrase.count)):
			errorStackView.isHidden = true
			activateContinueButton(false)
		default:
			errorStackView.isHidden = false
			activateContinueButton(false)
		}
	}
}
