//
//  URLEncoding.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
	public func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
		guard let url = urlRequest.url else { throw APIError.missingURL }

		if var urlComponents = URLComponents(
			url: url,
			resolvingAgainstBaseURL: false
		), !parameters.isEmpty {
			urlComponents.queryItems = [URLQueryItem]()

			for (key, value) in parameters {
				let queryItem = URLQueryItem(
					name: key,
					value: "\(value)"
						.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
				)
				urlComponents.queryItems?.append(queryItem)
			}
			urlRequest.url = urlComponents.url
		}

		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.addHeaders(["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"])
		}
	}
    
    public func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws {
        guard let url = urlRequest.url else { throw APIError.missingURL }

        if var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) {
            urlComponents.queryItems = [URLQueryItem]()

            let mirror = Mirror(reflecting: parameters)

            mirror.children.forEach { child in
                let queryItem = URLQueryItem(
                    name: child.label!,
                    value: "\(child.value)"
                        .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.addHeaders(["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"])
        }
    }
}
