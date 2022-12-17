//
//  Pino_iOSUITests.swift
//  Pino-iOSUITests
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import XCTest

final class ImportWalletUITests: XCTestCase {
	// MARK: Private Properties

	private let app = XCUIApplication()
	private var importButton: XCUIElement!
	private var testSecretPhrase: [String]!
	private var seedPhraseMaxCount: Int!
	private let secretPhraseThirteenthWord = "thirteenth"
	private let introVM = IntroViewModel()
	private let validateSecretPhraseVM = ValidateSecretPhraseViewModel()

	// MARK: Internal Functions

	override internal func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
		seedPhraseMaxCount = validateSecretPhraseVM.maxSeedPhraseCount
		testSecretPhrase = Array(SeedPhraseMock.testWords.shuffled().prefix(seedPhraseMaxCount))
	}

	override internal func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	internal func testTypeSecretPhrase() throws {
		openImportWalletPage()
		openKeyboard()
		for (index, word) in testSecretPhrase.enumerated() {
			// Type words of the secret phrase
			app.typeText("\(word) ")
			if index == seedPhraseMaxCount - 1 {
				// Words count is 12
				checkImportButtonActivation(true)
				// Type 13th word
				app.typeText(secretPhraseThirteenthWord)
				checkImportButtonActivation(false)
				// delete 13th word
				for _ in secretPhraseThirteenthWord {
					checkImportButtonActivation(false)
					app.typeText(XCUIKeyboardKey.delete.rawValue)
				}
				// Words count is 12 again
				checkImportButtonActivation(true)
			} else {
				// Words count is less than 12
				checkImportButtonActivation(false)
			}
		}

		app.tap()
		importButton.tap()
	}

	internal func testSelectSuggestedWord() throws {
		openImportWalletPage()
		openKeyboard()

		let testWordsFirstLetter = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"]

		for (index, firstLetter) in testWordsFirstLetter.enumerated() {
			// Type first letter of word
			app.typeText(firstLetter)
			// Select first suggested word
			let firstSuggestedWord = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0)
			firstSuggestedWord.tap()
			if index == seedPhraseMaxCount - 1 {
				// Words count is 12
				checkImportButtonActivation(true)
				// Type 13th word
				for char in secretPhraseThirteenthWord {
					app.typeText(String(char))
				}
				checkImportButtonActivation(false)
				// delete 13th word
				for _ in secretPhraseThirteenthWord {
					checkImportButtonActivation(false)
					app.typeText(XCUIKeyboardKey.delete.rawValue)
				}
				// Words count is 12 again
				checkImportButtonActivation(true)
			} else {
				// Words count is less than 12
				checkImportButtonActivation(false)
			}
		}

		app.tap()
		importButton.tap()
	}

	internal func testPasteSecretPhrase() throws {
		openImportWalletPage()
		let pasteButton = app.buttons[validateSecretPhraseVM.pasteButtonTitle]

		// Paste 11 words
		UIPasteboard.general.string = Array(testSecretPhrase.prefix(seedPhraseMaxCount - 1)).joined(separator: " ")
		pasteButton.tap()
		checkImportButtonActivation(false)
		// Paste 13 words
		UIPasteboard.general.string = "\(testSecretPhrase.joined(separator: " ")) \(secretPhraseThirteenthWord)"
		pasteButton.tap()
		checkImportButtonActivation(false)
		// Paste 12 words
		UIPasteboard.general.string = testSecretPhrase.joined(separator: " ")
		pasteButton.tap()
		checkImportButtonActivation(true)

		app.tap()
		importButton.tap()
	}

	// MARK: Private Functions

	private func openImportWalletPage() {
		// UI tests must launch the application
		app.launch()
		// Go to import secret phrase Page
		let importWalletButton = app.buttons[introVM.importButtonTitle]
		importWalletButton.tap()
		importButton = app.buttons[validateSecretPhraseVM.continueButtonTitle]
		checkImportButtonActivation(false)
	}

	private func openKeyboard() {
		let seedPhraseTextField = app.textViews.element(boundBy: 0)
		seedPhraseTextField.tap()
	}

	private func checkImportButtonActivation(_ buttonShouldEnabled: Bool) {
		if buttonShouldEnabled {
			XCTAssertTrue(importButton.isEnabled)
		} else {
			XCTAssertFalse(importButton.isEnabled)
		}
	}
}
