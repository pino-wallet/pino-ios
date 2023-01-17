//
//  HomepageUITests.swift
//  Pino-iOSUITests
//
//  Created by Mohi Raoufi on 1/8/23.
//

import Network
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
		app.launchArguments.append(LaunchArguments.isRunningUITests.rawValue)
	}

	override internal func tearDownWithError() throws {}

	// MARK: Private Methods

	internal func testPullToRefresh() {
		app.launch()
		let balanceTitle = app.staticTexts.element(boundBy: 2).label
		let balanceLabel = app.staticTexts[balanceTitle]
		let tabBar = app.tabBars.element(boundBy: 0)
		// Pull to refresh
		balanceLabel.press(forDuration: 0, thenDragTo: tabBar)
		// Wait until refresh ends
		let predicate = NSPredicate(block: { _, _ -> Bool in
			balanceLabel.frame.minY == 111
		})
		wait(for: [expectation(for: predicate, evaluatedWith: balanceLabel, handler: nil)], timeout: 10)
		testToastView()
	}

	internal func testCopyWalletAddress() {
		app.launch()
		app.navigationBars.element(boundBy: 0).buttons.element(boundBy: 1).tap()
		XCTAssert(app.staticTexts["Copied!"].exists)
	}

	internal func testSecurityMode() {
		app.launch()
		let balanceLabel = app.staticTexts.element(boundBy: 2)
		let showBalanceButton = app.staticTexts["Show balance"]
		// Enable security mode
		balanceLabel.tap()
		XCTAssertEqual(balanceLabel.label, securityText)
		XCTAssert(showBalanceButton.exists)
		checkAssetsSecurityMode(isEnabled: true)
		// Disable security mode
		balanceLabel.tap()
		XCTAssertNotEqual(balanceLabel.label, securityText)
		XCTAssertFalse(showBalanceButton.exists)
		checkAssetsSecurityMode(isEnabled: false)
	}

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

	private func testToastView() {
		// Check internet connection
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			if path.status == .satisfied {
				// Test not showing the toast view
				XCTAssertFalse(self.app.staticTexts["No internet connection"].exists)
				monitor.cancel()
			} else {
				// Test showing the toast view
				XCTAssert(self.app.staticTexts["No internet connection"].exists)
				monitor.cancel()
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}
}
