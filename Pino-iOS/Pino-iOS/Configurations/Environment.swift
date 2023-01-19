//
//  Environment.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

enum NetworkEnvironment {
	case qa
	case production
	case staging
}

enum Environment {
	static var networkEnvironment: NetworkEnvironment {
		.staging
	}

	static var apiBaseURL: URL {
		switch networkEnvironment {
		case .staging, .production, .qa:
			return URL(string: "https://reqres.in/api/")!
		}
	}
}
