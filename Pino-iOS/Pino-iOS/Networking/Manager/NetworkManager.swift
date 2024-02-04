//
//  NetworkManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/15/23.
//

import Combine
import Foundation

struct NetworkManager<EndPoint: EndpointType>: NetworkRouter {
	// MARK: - Public Methods

	public func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError> {
		do {
			let request = try endpoint.request()
			let requestPublisher = URLSession.shared.dataTaskPublisher(for: request)
				.tryMap { data, response -> T in
					guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
						throw APIError.failedRequest
					}

					NetworkLogger.log(request: request, response: response)
					try checkStatusCode(responseData: data, statusCode: statusCode)

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
					mapError(error)
				}
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()

			return requestPublisher
		} catch let error as APIError {
			return Fail(error: error).eraseToAnyPublisher()
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	public func requestData(_ endpoint: EndPoint) -> AnyPublisher<Data, APIError> {
		do {
			let request = try endpoint.request()
			let requestPublisher = URLSession.shared.dataTaskPublisher(for: request)
				.tryMap { data, response -> Data in
					guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
						throw APIError.failedRequest
					}

//					NetworkLogger.log(request: request, response: response)

					try checkStatusCode(responseData: data, statusCode: statusCode)

					// For cases when response body is empty
					if statusCode == 204 {
						return .empty
					}

					return data
				}
				.mapError { error -> APIError in
					mapError(error)
				}
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()

			return requestPublisher
		} catch let error as APIError {
			return Fail(error: error).eraseToAnyPublisher()
		} catch {
			fatalError(error.localizedDescription)
		}
	}

	// MARK: - Private Methods

	private func checkStatusCode(responseData: Data, statusCode: Int) throws {
		guard (200 ..< 300).contains(statusCode) else {
			print("Error:------------------")
			print(String(data: responseData, encoding: String.Encoding.utf8)! as String)
			print("------------------------")
			if statusCode == 401 {
				throw APIError.unauthorized
			} else if statusCode == 404 {
				throw APIError.notFound
			} else {
				throw APIError.failedRequest
			}
		}
		print("SUCCESS:------------------")
		print(String(data: responseData, encoding: String.Encoding.utf8)! as String)
		print("------------------------")
	}

	private func mapError(_ error: Error) -> APIError {
		switch error {
		case let apiError as APIError:
			return apiError
		case URLError.notConnectedToInternet:
			return .unreachable
		default:
			return .failedRequest
		}
	}
}
