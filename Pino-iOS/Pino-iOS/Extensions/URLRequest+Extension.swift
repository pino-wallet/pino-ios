//
//  URLRequest+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/19/23.
//

import Foundation

extension URLRequest {
	// MARK: Public Methods

	public mutating func addHeaders(_ headers: HTTPHeaders) {
		headers.forEach { header, value in
			addValue(value, forHTTPHeaderField: header)
		}
	}

	public mutating func addJSONContentType() {
		if value(forHTTPHeaderField: "Content-Type") == nil {
			addHeaders(["Content-Type": "application/json"])
		}
	}
}
