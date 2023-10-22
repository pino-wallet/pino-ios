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
    
	public static var chainID: String {
        try! Configuration.value(for: "NETWORK_CHAIN_ID")
	}
    
    public static var rpcURL: String {
        try! Configuration.value(for: "NETWORK_RPC_URL")
    }
    
    public static var current: Environment {
        let devMode = UserDefaults.standard.bool(forKey: "isInDevMode")
        
        if devMode {
            return .devNet
        } else {
            return .mainNet
        }
        
//        let config: String = try! Configuration.value(for: "CONFIG")
//        if config == "MainNet" {
//            return .mainNet
//        } else if config == "DevNet" {
//            return .devNet
//        } else {
//            fatalError("Wrong ENV Config")
//        }
    }
    
}
