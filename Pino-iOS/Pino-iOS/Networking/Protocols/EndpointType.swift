//
//  EndpointTypeProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/15/23.
//

import Foundation

// <#Description#>
// Every Endpoint we define in system should confirm to `EndpointType`
protocol EndpointType {
	func request() throws -> URLRequest
	var url: URL { get }
	var baseURL: URL { get }
	var path: String { get }
	var task: HTTPTask { get }
	var httpMethod: HTTPMethod { get }
	var headers: HTTPHeaders { get }
}

// `baseURL` should be set based on environment
extension EndpointType {
	var baseURL: URL {
		Environment.apiBaseURL
	}
}
