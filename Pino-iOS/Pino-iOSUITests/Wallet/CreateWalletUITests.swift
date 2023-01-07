//
//  CreateWalletUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 11/29/22.
//

import XCTest

@testable import Pino_iOS
final class CreateWalletUITests: XCTestCase {
	// MARK: Private Properties

	private let app = XCUIApplication()
	private var saveButton: XCUIElement!
	private var verifyButton: XCUIElement!
	private let secretPhraseCells = XCUIApplication().collectionViews.element(boundBy: 0).cells
	private let sortedSecretPhraseCells = XCUIApplication().collectionViews.element(boundBy: 1).cells
	private var testSecretPhrase: [String] = []
	private var errorLabel: XCUIElement!
	private let introVM = IntroViewModel()
	private let showSecretPhraseVM = ShowSecretPhraseViewModel()
	private let verifySecretPhraseVM = VerifySecretPhraseViewModel([])

	// MARK: Internal Functions

	override internal func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
		errorLabel = app.staticTexts[verifySecretPhraseVM.errorTitle]
	}

	override internal func tearDownWithError() throws {}

	internal func testCreateWallet() throws {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		checkSecretPhraseCount()
		openVerifySecretPhrasePage()
		selectInvalidSecretPhraseWords()
		deselectAllSecretPhraseWords()
		selectValidSecretPhraseWords()
		verifyButton.tap()
	}

	internal func testShowSecretPhrase() {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		checkSecretPhraseCount()
		checkSecretPhraseSequence(in: secretPhraseCells)
	}

	internal func testInvalidSecretPhrase() throws {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		openVerifySecretPhrasePage()
		selectInvalidSecretPhraseWords()
		deselectAllSecretPhraseWords()
	}

	internal func testValidSecretPhrase() {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		openVerifySecretPhrasePage()
		selectValidSecretPhraseWords()
		verifyButton.tap()
	}

	// MARK: Private Functions

	private func showSecretPhraseWords() {
		let tapToReveal = app.staticTexts[showSecretPhraseVM.revealButtonTitle]
		tapToReveal.tap()
		XCTAssertTrue(saveButton.isEnabled)
		// Save Secret phrase words from collection view
		for index in 0 ..< secretPhraseCells.count {
			testSecretPhrase.append(secretPhraseCells.element(boundBy: index).staticTexts.element(boundBy: 1).label)
		}
	}

	private func selectValidSecretPhraseWords() {
		// Select words in the order of secret phrase words
		for word in testSecretPhrase {
			secretPhraseCells.staticTexts[word].tap()
			checkErrorDisplay(false)
		}
		checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		checkVerifyButtonActivation(true)
	}

	private func selectInvalidSecretPhraseWords() {
		// Select words in the order of collection view cells
		for index in 0 ..< secretPhraseCells.count {
			secretPhraseCells.element(boundBy: index).tap()
		}
		checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		checkErrorDisplay(true)
		checkVerifyButtonActivation(false)
	}

	private func deselectAllSecretPhraseWords() {
		// Deselect all words
		for _ in 0 ..< sortedSecretPhraseCells.count {
			sortedSecretPhraseCells.firstMatch.tap()
			checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		}
		checkErrorDisplay(false)
		checkVerifyButtonActivation(false)
	}

	private func checkSecretPhraseCount() {
		let seedPhrase = app.collectionViews.firstMatch.cells
		XCTAssertEqual(seedPhrase.count, 12)
	}

	private func checkSecretPhraseSequence(in secretPhraseCell: XCUIElementQuery) {
		for index in 0 ..< secretPhraseCell.count {
			XCTAssertEqual(
				secretPhraseCell.element(boundBy: index).staticTexts.element(boundBy: 0).label,
				String(index + 1)
			)
		}
	}

	private func checkVerifyButtonActivation(_ buttonShouldEnabled: Bool) {
		if buttonShouldEnabled {
			XCTAssertTrue(verifyButton.isEnabled)
		} else {
			XCTAssertFalse(verifyButton.isEnabled)
		}
	}

	private func checkErrorDisplay(_ errorShouldDisplay: Bool) {
		if errorShouldDisplay {
			XCTAssertTrue(errorLabel.exists)
		} else {
			XCTAssertFalse(errorLabel.exists)
		}
	}

	private func openShowSecretPhrasePage() {
		// UI tests must launch the application
		app.launch()
		let createWalletButton = app.buttons[introVM.createButtonTitle]
		// Go to show secret phrase Page
		createWalletButton.tap()
		saveButton = app.buttons[showSecretPhraseVM.continueButtonTitle]
		XCTAssertFalse(saveButton.isEnabled)
	}

	private func openVerifySecretPhrasePage() {
		saveButton.tap()
		verifyButton = app.buttons[verifySecretPhraseVM.continueButtonTitle]
	}
}
