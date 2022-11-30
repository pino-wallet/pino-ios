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
	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testTypeSecretPhrase() throws {
		openImportWalletPage()
		// Test import button activation and deactivation
		let seedPhraseTextField = app.textViews.element(boundBy: 0)
		seedPhraseTextField.tap()
		app.typeText("a ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("b ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("c ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("d ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("e ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("f ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("g ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("h ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("i ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("j ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("k ")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("l")
		XCTAssertTrue(importButton.isEnabled)
		app.typeText(" ")
		XCTAssertTrue(importButton.isEnabled)
		app.typeText("m")
		XCTAssertFalse(importButton.isEnabled)
		app.typeText(XCUIKeyboardKey.delete.rawValue)
		app.typeText(XCUIKeyboardKey.return.rawValue)
		importButton.tap()
	}

	func testSelectSuggestedWord() throws {
		openImportWalletPage()
		let seedPhraseTextField = app.textViews.element(boundBy: 0)
		seedPhraseTextField.tap()

		app.typeText("a")
		let firstSuggestedWord = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0)
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("b")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("c")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("d")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("e")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("f")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("g")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("h")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("i")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("j")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("k")
		firstSuggestedWord.tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText("l")
		firstSuggestedWord.tap()
		XCTAssertTrue(importButton.isEnabled)
		app.tap()
		importButton.tap()
		createPasscode()
		//        app.typeText("m")
//		firstSuggestedWord.tap()
//		XCTAssertFalse(importButton.isEnabled)
	}

	func createPasscode() {
		app.keys["1"].tap()
		app.keys["2"].tap()
		app.keys["3"].tap()
		app.keys["4"].tap()
		app.keys["5"].tap()
		app.keys["6"].tap()
		sleep(1)

		app.keys["1"].tap()
		app.keys["2"].tap()
		app.keys["3"].tap()
		app.keys["4"].tap()
		app.keys["5"].tap()
		app.keys["0"].tap()
		sleep(1)

		app.keys["1"].tap()
		app.keys["2"].tap()
		app.keys["3"].tap()
		app.keys["4"].tap()
		app.keys["5"].tap()
		app.keys["6"].tap()
	}

	func testPasteSecretPhrase() throws {
		openImportWalletPage()
		let pasteButton = app.buttons["Paste"]

		// Paste 11 words
		UIPasteboard.general.string = "a b c d e f g h i j k "
		pasteButton.tap()
		XCTAssertFalse(importButton.isEnabled)
		// Paste 12 words
		UIPasteboard.general.string = "a b c d e f g h i j k l"
		pasteButton.tap()
		XCTAssertTrue(importButton.isEnabled)
		// Paste 13 words
		UIPasteboard.general.string = "a b c d e f g h i j k l m"
		pasteButton.tap()
		XCTAssertFalse(importButton.isEnabled)
	}

	func openImportWalletPage() {
		// UI tests must launch the application
		app.launch()
		// Go to import secret phrase Page
		let importWalletButton = app.buttons.element(boundBy: 1)
		importWalletButton.tap()
		importButton = app.buttons["Import"]
		XCTAssertFalse(importButton.isEnabled)
	}
}
