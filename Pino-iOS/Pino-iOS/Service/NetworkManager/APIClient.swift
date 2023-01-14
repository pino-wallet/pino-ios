//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class APIClient: APIService {
	// MARK: - Properties

	let keychainService: KeychainWrapper!

	// MARK: - Initialization

	init(keychainService: KeychainWrapper) {
		self.keychainService = keychainService
	}

	func transactions() -> AnyPublisher<[Transaction], APIError> {
		request(.transactions)
	}

	private func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
		let request = try! endpoint.request(privateKey: keychainService.get("privateKey"))
		return URLSession.shared.dataTaskPublisher(for: request)
			.retry(2)
			.tryMap { data, response -> T in
				guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
					throw APIError.failedRequest
				}

                guard statusCode.isSuccess else {
					if statusCode == 401 {
						throw APIError.unauthorized
					} else {
						throw APIError.failedRequest
					}
				}

				// For cases when response body is empty
				if statusCode == 204, let noContent = NoContent() as? T {
					return noContent
				}

				do {
					return try JSONDecoder().decode(T.self, from: data)
				} catch {
					print("Unable to handle request:\(error)")
					throw APIError.invalidRequest
				}
			}
			.mapError { error -> APIError in
				switch error {
				case let apiError as APIError:
					return apiError
				case URLError.notConnectedToInternet:
					return .unreachable
				default:
					return .failedRequest
				}
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

struct Transaction: Codable {}

struct NoContent: Codable {}


