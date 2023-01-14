//
//  APIClientTest.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/13/23.
//

import Combine
@testable import Pino_iOS
import XCTest

final class APIClientTest: XCTestCase {
	// MARK: - Properties

	private var subscriptions: Set<AnyCancellable> = []

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testTransactions() {
		let expectation = XCTestExpectation(description: "Fetch transactions")
		let apiClient = APIClient(keychainService: MockKeychainService())

		apiClient.transactions().sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				expectation.fulfill()
			case .failure:
				XCTFail("Req failed")
			}
		}) { transactions in
			XCTAssertNotNil(transactions)
		}.store(in: &subscriptions)

		waitForExpectations(timeout: 1.5)
	}

	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		measure {
			// Put the code you want to measure the time of here.
		}
	}
}
