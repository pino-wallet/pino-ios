//
//  CreatePasscodeUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 11/29/22.
//

@testable import Pino_iOS
import XCTest

final class CreatePasscodeUITests: XCTestCase {
	// MARK: Private Properties

	private let app = XCUIApplication()
	private var errorLabel: XCUIElement!
	private let testPassCode = ["1", "2", "3", "4", "5", "6"]
	private let invalidPasscode = ["1", "2", "3", "4", "5", "0"]
	private let passcodeVM = VerifyPassViewModel(
		finishPassCreation: {},
		onErrorHandling: { _ in },
		hideError: {},
		selectedPasscode: ""
	)

	// MARK: Internal Functions

	override internal func setUpWithError() throws {
		continueAfterFailure = false
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
		errorLabel = app.staticTexts[passcodeVM.errorTitle]
	}

	override internal func tearDownWithError() throws {}

	internal func testPasscode() throws {
		let createWalletUITests = CreateWalletUITests()
		try createWalletUITests.setUpWithError()
		createWalletUITests.testValidSecretPhrase()
		createPasscode()
		verifyInvalidPasscode()
		verifyValidPasscode()
	}

	// MARK: Private Functions

	private func createPasscode() {
		sleep(1)
		for number in testPassCode {
			app.keys[number].tap()
		}
	}

	private func verifyInvalidPasscode() {
		sleep(1)
		for number in invalidPasscode {
			app.keys[number].tap()
		}
		checkErrorDisplay(true)
	}

	private func verifyValidPasscode() {
		sleep(1)
		for number in testPassCode {
			app.keys[number].tap()
			checkErrorDisplay(false)
		}
	}

	private func checkErrorDisplay(_ errorShouldDisplay: Bool) {
		if errorShouldDisplay {
			XCTAssertTrue(errorLabel.exists)
		} else {
			XCTAssertFalse(errorLabel.exists)
		}
	}
}
