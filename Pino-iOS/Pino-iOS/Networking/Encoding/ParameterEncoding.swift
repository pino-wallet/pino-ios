//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

public enum ParameterEncoding {
	case urlEncoding
	case jsonEncoding
	case urlAndJsonEncoding

	// MARK: - Public Methods

	public func encode(
		urlRequest: inout URLRequest,
		bodyParameters: BodyParamsType? = nil,
		urlParameters: HTTPParameters?
	) throws {
		do {
			switch self {
			case .urlEncoding:
				guard let urlParameters = urlParameters else { return }
				try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

			case .jsonEncoding:
				guard let bodyParameters = bodyParameters else { return }
				try encodeBodyParams(urlRequest: &urlRequest, params: bodyParameters)
			case .urlAndJsonEncoding:
				guard let bodyParameters = bodyParameters,
				      let urlParameters = urlParameters else { return }
				try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
				try encodeBodyParams(urlRequest: &urlRequest, params: bodyParameters)
			}
		} catch {
			throw error
		}
	}

	// MARK: Private Methods

	private func encodeBodyParams(urlRequest: inout URLRequest, params: BodyParamsType) throws {
		switch params {
		case let .object(object):
			try BodyParameterEncoder().encode(urlRequest: &urlRequest, with: object)
		case let .json(json):
			try BodyParameterEncoder().encode(urlRequest: &urlRequest, with: json)
		}
	}
}
