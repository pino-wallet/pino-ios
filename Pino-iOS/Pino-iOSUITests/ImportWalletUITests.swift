//
//  Pino_iOSUITests.swift
//  Pino-iOSUITests
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import XCTest

final class ImportWalletUITests: XCTestCase {
	let app = XCUIApplication()
	var importButton: XCUIElement!
	let testSecretPhrase = Array(MockSeedPhrase.wordList.shuffled().prefix(12))
	let secretPhraseThirteenthWord = "thirteenth"

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testTypeSecretPhrase() throws {
		openImportWalletPage()
		openKeyboard()
		for (index, word) in testSecretPhrase.enumerated() {
			// Type words of the secret phrase
			app.typeText("\(word) ")
			if index == 11 {
				// Words count is 12
				testImportButtonActivation(true)
				// Type 13th word
				app.typeText(secretPhraseThirteenthWord)
				testImportButtonActivation(false)
				// delete 13th word
				for _ in secretPhraseThirteenthWord {
					testImportButtonActivation(false)
					app.typeText(XCUIKeyboardKey.delete.rawValue)
				}
				// Words count is 12 again
				testImportButtonActivation(true)
			} else {
				// Words count is less than 12
				testImportButtonActivation(false)
			}
		}

		openCreatePasscode()
	}

	func testSelectSuggestedWord() throws {
		openImportWalletPage()
		openKeyboard()

		let testWordsFirstLetter = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"]

		for (index, firstLetter) in testWordsFirstLetter.enumerated() {
			// Type first letter of word
			app.typeText(firstLetter)
			// Select first suggested word
			let firstSuggestedWord = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0)
			firstSuggestedWord.tap()
			if index == 11 {
				// Words count is 12
				testImportButtonActivation(true)
				// Type 13th word
				for char in secretPhraseThirteenthWord {
					app.typeText(String(char))
				}
				testImportButtonActivation(false)
				// delete 13th word
				for _ in secretPhraseThirteenthWord {
					testImportButtonActivation(false)
					app.typeText(XCUIKeyboardKey.delete.rawValue)
				}
				// Words count is 12 again
				testImportButtonActivation(true)
			} else {
				// Words count is less than 12
				testImportButtonActivation(false)
			}
		}

		openCreatePasscode()
	}

	func testPasteSecretPhrase() throws {
		openImportWalletPage()
		let pasteButton = app.buttons["Paste"]

		// Paste 11 words
		UIPasteboard.general.string = Array(testSecretPhrase.prefix(11)).joined(separator: " ")
		pasteButton.tap()
		testImportButtonActivation(false)
		// Paste 13 words
		UIPasteboard.general.string = testSecretPhrase.joined(separator: " ") + " thirteenth"
		pasteButton.tap()
		testImportButtonActivation(false)
		// Paste 12 words
		UIPasteboard.general.string = testSecretPhrase.joined(separator: " ")
		pasteButton.tap()
		testImportButtonActivation(true)

		openCreatePasscode()
	}

	func openImportWalletPage() {
		// UI tests must launch the application
		app.launch()
		// Go to import secret phrase Page
		let importWalletButton = app.buttons.element(boundBy: 1)
		importWalletButton.tap()
		importButton = app.buttons["Import"]
		testImportButtonActivation(false)
	}

	func openKeyboard() {
		let seedPhraseTextField = app.textViews.element(boundBy: 0)
		seedPhraseTextField.tap()
	}

	func testImportButtonActivation(_ isActive: Bool) {
		if isActive {
			XCTAssertTrue(importButton.isEnabled)
		} else {
			XCTAssertFalse(importButton.isEnabled)
		}
	}

	func openCreatePasscode() {
		app.tap()
		importButton.tap()
		let createPasscodeUITest = CreatePasscodeUITests()
		createPasscodeUITest.createPasscode()
		createPasscodeUITest.verifyValidPasscode()
	}
}
