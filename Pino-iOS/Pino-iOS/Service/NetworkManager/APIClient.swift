//
//  APIClient.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Combine
import Foundation

final class APIClient: TransactionsAPIService {
    
    
	// MARK: - Properties
    let networkManager = NetworkManager<TransactionsEndpoints>(keychainService: KeychainSwift())
    
	// MARK: - Initialization

	func transactions() -> AnyPublisher<[Transaction], APIError> {
        networkManager.request(.transactions)
	}

    func transactionDetail(id: String) -> AnyPublisher<Transaction, APIError> {
        
    }
}

struct Transaction: Codable {}

struct NoContent: Codable {}

protocol NetworkRouter {
    associatedtype EndPoint: EndpointType
    func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError>
}

struct NetworkManager<EndPoint: EndpointType>: NetworkRouter {
    
    let keychainService: KeychainWrapper!
    
    func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError> {

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
