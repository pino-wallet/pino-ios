//
//  VerifySecretPhraseView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//
// swiftlint: disable force_cast
// swiftlint: disable trailing_comma

import UIKit

class VerifySecretPhraseView: UIView {
	// MARK: Private Properties

	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let contentStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let titleLabel = PinoLabel(style: .title, text: nil)
	private let descriptionLabel = PinoLabel(style: .description, text: nil)
	private let collectionsStackView = UIStackView()
	private let sortedPhraseBoxView = UIView()
	private let sortedPhraseCollectionView = SecretPhraseCollectionView()
	private let errorStackView = UIStackView()
	private let errorLabel = UILabel()
	private let errorIcon = UIImageView()
	private let randomPhraseCollectionView = SecretPhraseCollectionView()
	private let continueButton = PinoButton(style: .deactive, title: "Continue")
	private var createWallet: ([String]) -> Void
	private var secretPhraseVM: VerifySecretPhraseViewModel

	// MARK: Initializers

	init(_ secretPhraseVM: VerifySecretPhraseViewModel, createWallet: @escaping (([String]) -> Void)) {
		self.createWallet = createWallet
		self.secretPhraseVM = secretPhraseVM
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
		guard let index = secretPhraseVM.randomSecretPhraseList.firstIndex(of: selectedWord) else { return }
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
		case secretPhraseVM.userSecretPhraseList:
			errorStackView.isHidden = true
			continueButton.style = .active
		// Some words are selected in the correct order
		case Array(secretPhraseVM.userSecretPhraseList.prefix(upTo: sortedWords.count)):
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
		randomPhraseCollectionView.secretWords = secretPhraseVM.randomSecretPhraseList
		randomPhraseCollectionView.cellStyle = .unordered
		sortedPhraseCollectionView.secretWords = []

		contentStackView.addArrangedSubview(titleStackView)
		contentStackView.addArrangedSubview(collectionsStackView)
		collectionsStackView.addArrangedSubview(sortedPhraseBoxView)
		collectionsStackView.addArrangedSubview(randomPhraseCollectionView)
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(descriptionLabel)
		errorStackView.addArrangedSubview(errorIcon)
		errorStackView.addArrangedSubview(errorLabel)
		sortedPhraseBoxView.addSubview(sortedPhraseCollectionView)
		sortedPhraseBoxView.addSubview(errorStackView)
		contentView.addSubview(contentStackView)
		contentView.addSubview(continueButton)
		scrollView.addSubview(contentView)
		addSubview(scrollView)

		continueButton.addAction(UIAction(handler: { _ in
			self.createWallet(self.sortedPhraseCollectionView.secretWords)
		}), for: .touchUpInside)

		randomPhraseCollectionView.wordSelected = { secretPhraseword in
			self.selectSeedPhraseCell(secretPhraseword)
		}
		sortedPhraseCollectionView.wordSelected = { secretPhraseword in
			self.deselectSeedPhraseCell(secretPhraseword)
		}
	}

	private func setupStyle() {
		titleLabel.text = secretPhraseVM.title
		descriptionLabel.text = secretPhraseVM.description
		errorLabel.text = secretPhraseVM.errorTitle
		continueButton.title = secretPhraseVM.continueButtonTitle

		errorIcon.image = secretPhraseVM.errorIcon

		backgroundColor = .Pino.secondaryBackground
		sortedPhraseBoxView.backgroundColor = .Pino.background

		errorLabel.textColor = .Pino.errorRed
		errorIcon.tintColor = .Pino.errorRed

		errorLabel.font = .PinoStyle.mediumCallout

		contentStackView.axis = .vertical
		titleStackView.axis = .vertical
		collectionsStackView.axis = .vertical
		errorStackView.axis = .horizontal

		contentStackView.spacing = 36
		titleStackView.spacing = 16
		collectionsStackView.spacing = 18
		errorStackView.spacing = 5

		errorLabel.textAlignment = .center
		errorStackView.alignment = .center

		errorStackView.isHidden = true
	}

	private func setupContstraint() {
		scrollView.pin(
			.allEdges
		)
		contentView.pin(
			.allEdges,
			.width
		)
		contentStackView.pin(
			.horizontalEdges,
			.top(padding: 25)
		)
		collectionsStackView.pin(
			.horizontalEdges
		)
		titleStackView.pin(
			.horizontalEdges(padding: 16)
		)
		continueButton.pin(
			.bottom(padding: 8),
			.horizontalEdges(padding: 16)
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

		NSLayoutConstraint.activate([
			contentView.heightAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.heightAnchor),
			continueButton.topAnchor.constraint(greaterThanOrEqualTo: contentStackView.bottomAnchor, constant: 64),
		])
	}
}
