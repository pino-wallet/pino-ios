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

	public static var chainID: Int {
		switch current {
            case .mainNet, .pinoNode:
			return 1
		case .devNet:
			return 1337
		}
	}

	public static var readRPCURL: String {
        return "https://node.pino.xyz"
	}
    
    public static var writeRPCURL: String {
        switch current {
            case .mainNet:
                return "https://rpc.ankr.com/eth"
            case .devNet:
                return "https://ganache.pino.xyz"
            case .pinoNode:
                return "https://ganache.pino.xyz"
        }
    }

	public static var current: Environment {
		let devMode = UserDefaults.standard.bool(forKey: "isInDevMode")

		if devMode {
			return .pinoNode
		} else {
			return .mainNet
		}
	}
}
