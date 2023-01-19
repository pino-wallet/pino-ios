//
//  URLRequest+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/19/23.
//

import Foundation

extension URLRequest {
	mutating func addHeaders(_ headers: HTTPHeaders) {
		headers.forEach { header, value in
			addValue(value, forHTTPHeaderField: header)
		}
	}
}
