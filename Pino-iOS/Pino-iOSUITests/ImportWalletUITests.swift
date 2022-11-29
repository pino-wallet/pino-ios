//
//  Pino_iOSUITests.swift
//  Pino-iOSUITests
//
//  Created by Sobhan Eskandari on 11/5/22.
//

import XCTest

// swiftlint:disable type_name
final class ImportWalletUITests: XCTestCase {
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests
		// before they run. The setUp method is a good place to do this.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testImportSecretPhrase() throws {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()
		app.launch()
		// Go to import secret phrase Page
		let importWalletButton = app.buttons.element(boundBy: 1)
		importWalletButton.tap()
		let importButton = app.buttons["Import"]
		XCTAssertFalse(importButton.isEnabled)
		// Test import button activation and deactivation
		let seedPhraseTextField = app.textViews.element(boundBy: 0)
		seedPhraseTextField.tap()
		app.keys["A"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["b"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["c"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["d"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["e"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["f"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["g"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["h"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["i"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["j"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["k"].tap()
		app.keys["space"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.keys["l"].tap()
		XCTAssertTrue(importButton.isEnabled)
		app.keys["space"].tap()
		XCTAssertTrue(importButton.isEnabled)
		app.keys["m"].tap()
		XCTAssertFalse(importButton.isEnabled)
		app.typeText(XCUIKeyboardKey.delete.rawValue)
		app.typeText(XCUIKeyboardKey.return.rawValue)
		importButton.tap()
	}

	func testLaunchPerformance() throws {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTApplicationLaunchMetric()]) {
				XCUIApplication().launch()
			}
		}
	}
}
