//
//  CreateWalletUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 11/29/22.
//

import XCTest

final class CreateWalletUITests: XCTestCase {
	let app = XCUIApplication()
	var saveButton: XCUIElement!
	var verifyButton: XCUIElement!
	let secretPhraseCells = XCUIApplication().collectionViews.element(boundBy: 0).cells
	let sortedSecretPhraseCells = XCUIApplication().collectionViews.element(boundBy: 1).cells
	var testSecretPhrase: [String] = []
	let errorLabel = XCUIApplication().staticTexts["Invalid order! Try again"]

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
	}

	override func tearDownWithError() throws {}

	func testCreateWallet() throws {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		checkSecretPhraseCount()
		openVerifySecretPhrasePage()
		selectInvalidSecretPhraseWords()
		deselectAllSecretPhraseWords()
		selectValidSecretPhraseWords()
		openCreatePasscode()
	}

	func testShowSecretPhrase() {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		checkSecretPhraseCount()
		checkSecretPhraseSequence(in: secretPhraseCells)
	}

	func testInvalidSecretPhrase() throws {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		openVerifySecretPhrasePage()
		selectInvalidSecretPhraseWords()
		deselectAllSecretPhraseWords()
	}

	func testValidSecretPhrase() {
		openShowSecretPhrasePage()
		showSecretPhraseWords()
		openVerifySecretPhrasePage()
		selectValidSecretPhraseWords()
		openCreatePasscode()
	}

	func showSecretPhraseWords() {
		let tapToReveal = app.staticTexts["Tap to reveal"]
		tapToReveal.tap()
		XCTAssertTrue(saveButton.isEnabled)
		// Save Secret phrase words from collection view
		for index in 0 ..< secretPhraseCells.count {
			testSecretPhrase.append(secretPhraseCells.element(boundBy: index).staticTexts.element(boundBy: 1).label)
		}
	}

	func selectValidSecretPhraseWords() {
		// Select words in the order of secret phrase words
		for word in testSecretPhrase {
			secretPhraseCells.staticTexts[word].tap()
			checkErrorDisplay(false)
		}
		checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		checkVerifyButtonActivation(true)
	}

	func selectInvalidSecretPhraseWords() {
		// Select words in the order of collection view cells
		for index in 0 ..< secretPhraseCells.count {
			secretPhraseCells.element(boundBy: index).tap()
		}
		checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		checkErrorDisplay(true)
		checkVerifyButtonActivation(false)
	}

	func deselectAllSecretPhraseWords() {
		// Deselect all words
		for _ in 0 ..< sortedSecretPhraseCells.count {
			sortedSecretPhraseCells.firstMatch.tap()
			checkSecretPhraseSequence(in: sortedSecretPhraseCells)
		}
		checkErrorDisplay(false)
		checkVerifyButtonActivation(false)
	}

	func checkSecretPhraseCount() {
		let seedPhrase = app.collectionViews.firstMatch.cells
		XCTAssertEqual(seedPhrase.count, 12)
	}

	func checkSecretPhraseSequence(in secretPhraseCell: XCUIElementQuery) {
		for index in 0 ..< secretPhraseCell.count {
			XCTAssertEqual(
				secretPhraseCell.element(boundBy: index).staticTexts.element(boundBy: 0).label,
				String(index + 1)
			)
		}
	}

	func checkVerifyButtonActivation(_ isActive: Bool) {
		if isActive {
			XCTAssertTrue(verifyButton.isEnabled)
		} else {
			XCTAssertFalse(verifyButton.isEnabled)
		}
	}

	func checkErrorDisplay(_ isDisplay: Bool) {
		if isDisplay {
			XCTAssertTrue(errorLabel.exists)
		} else {
			XCTAssertFalse(errorLabel.exists)
		}
	}

	func openShowSecretPhrasePage() {
		// UI tests must launch the application
		app.launch()
		let createWalletButton = app.buttons.element(boundBy: 0)
		// Go to show secret phrase Page
		createWalletButton.tap()
		saveButton = app.buttons["I Saved"]
		XCTAssertFalse(saveButton.isEnabled)
	}

	func openVerifySecretPhrasePage() {
		saveButton.tap()
		verifyButton = app.buttons["Continue"]
	}

	func openCreatePasscode() {
		verifyButton.tap()
		let createPasscodeUITest = CreatePasscodeUITests()
		createPasscodeUITest.createPasscode()
		createPasscodeUITest.verifyValidPasscode()
	}
}
