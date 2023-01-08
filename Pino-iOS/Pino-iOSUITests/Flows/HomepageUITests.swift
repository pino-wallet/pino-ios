//
//  HomepageUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 1/8/23.
//

import Pino_iOS
import XCTest

final class HomepageUITests: XCTestCase {
	// MARK: Private Properties

	private let app = XCUIApplication()
	private let securityText = "••••••"
	private let assets = XCUIApplication().collectionViews.element(boundBy: 0).cells

	// MARK: Internal Methods

	override internal func setUpWithError() throws {
		continueAfterFailure = false
		//        app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
	}

	override internal func tearDownWithError() throws {}

	internal func testPullToRefresh() {
		app.launch()
		let balanceLabel = app.staticTexts.element(boundBy: 2)
		let tabBar = app.tabBars.element(boundBy: 0)
		balanceLabel.press(forDuration: 0, thenDragTo: tabBar)
	}

	internal func testCopyWalletAddress() throws {
		app.launch()
		app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
		XCTAssertNotNil(UIPasteboard.general.string)
	}

	internal func testSecurityMode() {
		let balanceLabel = app.staticTexts.element(boundBy: 2)
		let showBalanceButton = app.staticTexts["Show balance"]
		app.launch()
		balanceLabel.tap()
		XCTAssertEqual(balanceLabel.label, securityText)
		XCTAssert(showBalanceButton.exists)
		checkAssetsSecurityMode(isEnabled: true)
		balanceLabel.tap()
		XCTAssertNotEqual(balanceLabel.label, securityText)
		checkAssetsSecurityMode(isEnabled: false)
	}

	// MARK: Private Methods

	private func checkAssetsSecurityMode(isEnabled: Bool) {
		for index in 0 ..< assets.count {
			let asset = assets.element(boundBy: index)
			if isEnabled {
				XCTAssertEqual(asset.staticTexts.element(boundBy: 0).label, securityText)
				XCTAssertEqual(asset.staticTexts.element(boundBy: 1).label, securityText)
				XCTAssertEqual(asset.staticTexts.element(boundBy: 3).label, securityText)
			} else {
				XCTAssertNotEqual(asset.staticTexts.element(boundBy: 0).label, securityText)
				XCTAssertNotEqual(asset.staticTexts.element(boundBy: 1).label, securityText)
				XCTAssertNotEqual(asset.staticTexts.element(boundBy: 3).label, securityText)
			}
			XCTAssertNotEqual(asset.staticTexts.element(boundBy: 2).label, securityText)
		}
	}
}
