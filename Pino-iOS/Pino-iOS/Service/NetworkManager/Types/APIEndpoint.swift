//
//  APIEndpoint.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

protocol EndpointType {
    
    func request(privateKey: String?) throws -> URLRequest
    var url: URL { get }
    var baseURL: URL { get }
    var path: String { get }
    var httpBody: Data? { get }
    var httpMethod: HTTPMethod { get }
    var headers: Headers { get }

}

extension EndpointType {
    var baseURL: URL {
        Environment.apiBaseURL
    }
}

enum TransactionsEndpoints: EndpointType {
    
	// MARK: - Cases
    case transactions
    case transactionDetail(id: String)
    case removeTransaction(id: String)
    
	// MARK: - Properties
    
    func request(privateKey: String?) throws -> URLRequest {
		var request = URLRequest(url: url)
		request.addHeaders(headers)
		request.httpMethod = httpMethod.rawValue

		if requiresAuthentication {
			if let privateKey {
				print(privateKey)
				// Add privateKey as a token
			} else {
				throw APIError.unauthorized
			}
		}

		request.httpBody = httpBody

		return request
	}

    var requiresAuthentication: Bool {
		switch self {
		case .transactions,.transactionDetail,.removeTransaction:
			return true
		}
	}

    var httpBody: Data? {
		nil
	}

    var headers: Headers {
		[
			"Content-Type": "application/json",
			"X-API-TOKEN": "token",
		]
	}

    var url: URL {
        Environment.apiBaseURL.appendingPathComponent(path)
    }
    
    var path: String {
        switch self {
        case .transactions:
            return "transactions"
        case .transactionDetail(let id),.removeTransaction(let id):
            return "transactions/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self. {
        case .transactions,.transactionDetail,.removeTransaction:
			return .get
		}
	}
}

typealias Headers = [String: String]
typealias StatusCode = Int


extension URLRequest {
	fileprivate mutating func addHeaders(_ headers: Headers) {
		headers.forEach { header, value in
			addValue(value, forHTTPHeaderField: header)
		}
	}
}
