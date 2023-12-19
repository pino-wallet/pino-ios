//
//  Environment.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 1/12/23.
//

import Foundation

#warning("Environment file is temporary for when we add different Environments")
enum NetworkEnvironment {
	case qa
	case production
	case staging
}

enum Environment {
	case mainNet
	case devNet
	case pinoNode

	// MARK: Public Properties

	public static var networkEnvironment: NetworkEnvironment {
		.staging
	}

	public static var apiBaseURL: URL {
		switch networkEnvironment {
		case .staging, .production, .qa:
			return URL(string: "https://demo-api.pino.xyz/v1/")!
		}
	}

	// MARK: - Environments

	public static var current: Environment {
		let devMode = UserDefaults.standard.bool(forKey: "isInDevMode")

		return .devNet
		if devMode {
			return .devNet
		} else {
			return .mainNet
		}
	}
}
