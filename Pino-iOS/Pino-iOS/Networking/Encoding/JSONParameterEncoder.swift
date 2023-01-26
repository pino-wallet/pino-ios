//
//  JSONEncoding.swift
//  NetworkLayer
//
//  Created by Sobhan Eskandari
//  Copyright © 2023 Nito Labs. All rights reserved.
//

import Foundation

public struct BodyParameterEncoder: ParameterEncoder {
	
    // MARK: - Public Methods

	public func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
		do {
			let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			urlRequest.httpBody = jsonAsData
            urlRequest.addJSONContentType()
		} catch {
			throw APIError.encodingFailed
		}
	}

	public func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws {
		do {
            urlRequest.httpBody = try parameters.jsonData()
            urlRequest.addJSONContentType()
		} catch {
			throw APIError.encodingFailed
		}
	}
}

