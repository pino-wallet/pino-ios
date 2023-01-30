//
//  APISimulator.swift
//  Pino-iOSTests
//
//  Created by Sobhan Eskandari on 1/30/23.
//

import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift

internal enum APISimulator {
    // MARK: - Types

    enum Response {
        case data(data: Data)
        case file(name: String)
    }

    // MARK: - Stub API

    static func simulateFailure(endPoint: EndpointType, error: Error) -> HTTPStubsDescriptor {
        stub { request in
            request.url?.path == endPoint.path
        } response: { _ in
            HTTPStubsResponse(error: error)
        }
    }

    static func stubAPI(endPoint: EndpointType, statusCode: StatusCode, response: Response) -> HTTPStubsDescriptor {
        stub { request in
            request.url?.path == endPoint.path
        } response: { request in
            if statusCode.isSuccess {
                switch response {
                case let .data(data):
                    return HTTPStubsResponse(data: data, statusCode: Int32(statusCode), headers: nil)
                case let .file(name):
                    if let stubPath = OHPathForFile(name, APIClientTest.self) {
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
