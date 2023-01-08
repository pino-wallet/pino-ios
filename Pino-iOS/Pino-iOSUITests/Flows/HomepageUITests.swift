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
}
