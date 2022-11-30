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
	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {}

	func testShowSecretPhrase() {
		openCreateWallet()
		// Tap to reveal
		let tapToReveal = app.staticTexts["Tap to reveal"]
		tapToReveal.tap()
		XCTAssertTrue(saveButton.isEnabled)
	}

	func testSeedPhraseCount() {
		testShowSecretPhrase()
		let seedPhrase = app.collectionViews.firstMatch.cells
		XCTAssertEqual(seedPhrase.count, 12)
	}

	func openCreateWallet() {
		// UI tests must launch the application
		let app = XCUIApplication()
		app.launch()
		let createWalletButton = app.buttons.element(boundBy: 0)
		// Go to show secret phrase Page
		createWalletButton.tap()
		let savedButton = app.buttons.element(boundBy: 1)
		XCTAssertFalse(savedButton.isEnabled)
	}
}
