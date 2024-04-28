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
            return URL(string: "https://api.pino.xyz/v1/")!
		}
	}

	// MARK: - Environments

	public static var current: Environment {
		let devMode: Bool = UserDefaultsManager.isDevModeUser.getValue()!

		if devMode {
			return .devNet
		} else {
			return .mainNet
		}
	}
}
