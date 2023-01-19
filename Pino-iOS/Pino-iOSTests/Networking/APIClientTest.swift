//
//  APIClientTest.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/13/23.
//

import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Pino_iOS
import XCTest

final class APIClientTest: XCTestCase {
	// MARK: - Properties

	private var apiClient: APIClient!
	private var subscriptions: Set<AnyCancellable> = []
	private var stubsDescriptors: [HTTPStubsDescriptor] = []

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		apiClient = APIClient(keychainService: MockKeychainService())
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		stubsDescriptors.forEach { stub in
			HTTPStubs.removeStub(stub)
		}
	}

	func testTransactions_Success() {
		runTransactionsTests(statusCode: 201)
	}

	func testTransactions_Failure() {
		runTransactionsTests(statusCode: 401)
	}

	func testTransactions_NotFound() {
		runTransactionsTests(statusCode: 404)
	}

	func runTransactionsTests(statusCode: StatusCode) {
		let endPoint = Endpoint.transactions
		stubAPI(
			endPoint: endPoint,
			statusCode: statusCode,
			response: .file(name: endPoint.stubPath)
		)
		.store(in: &stubsDescriptors)

		let expectation = XCTestExpectation(description: "Fetch transactions")

		apiClient.transactions().sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				if !statusCode.isSuccess {
					XCTFail("Req failed")
				}
			case let .failure(error):
				if !statusCode.isSuccess {
					XCTFail("Req failed")
				}
				switch statusCode {
				case 401:
					XCTAssertEqual(error, APIError.unauthorized)
				default:
					XCTAssertEqual(error, APIError.failedRequest)
				}
			}
			expectation.fulfill()
		}) { transactions in
			XCTAssertNotNil(transactions)
		}.store(in: &subscriptions)

		waitForExpectations(timeout: 1.5)
	}
}

fileprivate enum Endpoint {
	// MARK: - Cases

	case transactions

	var path: String {
		switch self {
		case .transactions:
			return "transactions"
		}
	}

	var stubPath: String {
		switch self {
		case .transactions:
			return "transactions-mock"
		}
	}
}

extension APIClientTest {
	// MARK: - Types

	fileprivate enum Response {
		case data(data: Data)
		case file(name: String)
	}

	// MARK: - Stub API

	fileprivate func simulateFailure(endPoint: Endpoint, error: Error) -> HTTPStubsDescriptor {
		stub { request in
			request.url?.path == endPoint.path
		} response: { _ in
			HTTPStubsResponse(error: error)
		}
	}

	fileprivate func stubAPI(endPoint: Endpoint, statusCode: StatusCode, response: Response) -> HTTPStubsDescriptor {
		stub { request in
			request.url?.path == endPoint.path
		} response: { request in
			if statusCode.isSuccess {
				switch response {
				case let .data(data):
					return HTTPStubsResponse(data: data, statusCode: statusCode, headers: nil)
				case let .file(name):
					if let stubPath = OHPathForFile(name, type(of: self)) {
						return fixture(filePath: stubPath, status: 200, headers: [:])
					} else {
						fatalError("Stub file not found")
					}
				}

			} else {
				return HTTPStubsResponse(data: Data(), statusCode: Int32(statusCode), headers: [:])
			}
		}
	}
}
