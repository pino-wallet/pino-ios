//
//  NetworkManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/15/23.
//

import Combine
import Foundation

struct NetworkManager<EndPoint: EndpointType>: NetworkRouter {
	// MARK: Public Methods

	public func request<T: Codable>(_ endpoint: EndPoint) -> AnyPublisher<T, APIError> {
		do {
			let request = try endpoint.request()
			let requestPublisher = URLSession.shared.dataTaskPublisher(for: request)
				.tryMap { data, response -> T in
					guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
						throw APIError.failedRequest
					}
                    print(response.url?.absoluteString)
                    print(response)
                    log(request: request)
					guard (200 ..< 300).contains(statusCode) else {
						if statusCode == 401 {
							throw APIError.unauthorized
						} else if statusCode == 404 {
							throw APIError.notFound
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

			return requestPublisher
		} catch let error as APIError {
			return Fail(error: error).eraseToAnyPublisher()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
    
    func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
    }
}

