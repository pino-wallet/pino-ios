//
//  JSONEncoding.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public struct BodyParameterEncoder: ParameterEncoder {
	// MARK: - Public Methods

	public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
		do {
			let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			urlRequest.httpBody = jsonAsData
			if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.addHeaders(["Content-Type":"application/json"])
			}
		} catch {
			throw APIError.encodingFailed
		}
	}

	public func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws {
		do {
            urlRequest.httpBody = try parameters.jsonData()
			if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.addHeaders(["Content-Type":"application/json"])
			}
		} catch {
			throw APIError.encodingFailed
		}
	}
}
