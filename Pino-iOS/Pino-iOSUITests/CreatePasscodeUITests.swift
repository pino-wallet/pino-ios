//
//  CreatePasscodeUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 11/29/22.
//

import XCTest

final class CreatePasscodeUITests: XCTestCase {
	let app = XCUIApplication()
	let errorLabel = XCUIApplication().staticTexts["Incorrect, try again!"]
	let testPassCode = ["1", "2", "3", "4", "5", "6"]
	let invalidPasscode = ["1", "2", "3", "4", "5", "0"]

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
	}

	override func tearDownWithError() throws {}

	func testPasscode() throws {
		let createWalletUITests = CreateWalletUITests()
		createWalletUITests.openShowSecretPhrasePage()
		createWalletUITests.showSecretPhraseWords()
		createWalletUITests.openVerifySecretPhrasePage()
		createWalletUITests.selectValidSecretPhraseWords()
		createWalletUITests.verifyButton.tap()
		createPasscode()
		verifyInvalidPasscode()
		verifyValidPasscode()
	}

	func createPasscode() {
		sleep(1)
		for number in testPassCode {
			app.keys[number].tap()
		}
	}

	func verifyInvalidPasscode() {
		sleep(1)
		for number in invalidPasscode {
			app.keys[number].tap()
		}
		testErrorDisplay(true)
	}

	func verifyValidPasscode() {
		sleep(1)
		for number in testPassCode {
			app.keys[number].tap()
			testErrorDisplay(false)
		}
	}

	func testErrorDisplay(_ isDisplay: Bool) {
		if isDisplay {
			XCTAssertTrue(errorLabel.exists)
		} else {
			XCTAssertFalse(errorLabel.exists)
		}
	}
}
