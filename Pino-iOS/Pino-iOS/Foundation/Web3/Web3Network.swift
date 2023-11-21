//
//  Web3Network.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 10/22/23.
//

import Foundation
import Web3

public enum Web3Network: String {
	// MARK: - Cases

	case mainNet
	case arb
	case ganashDev
	case pinoNode

	// MARK: - Public Properties

	public static var current: Self {
		if Environment.current == .mainNet {
			return .mainNet
		} else if Environment.current != .mainNet {
			return .ganashDev
		} else {
			return .arb
		}
	}

	public static var chainID: EthereumQuantity {
		if current == .mainNet {
			return 1
		} else {
			return 1337
		}
	}

	public static var readRPC: Web3 {
		if current == .mainNet {
			return Web3(rpcURL: "https://node.pino.xyz")
		} else {
			return Web3(rpcURL: "https://ganache.pino.xyz")
		}
	}

	public static var writeRPC: Web3 {
		if current == .mainNet {
			return Web3(rpcURL: "https://rpc.ankr.com/eth")
		} else {
			return Web3(rpcURL: "https://ganache.pino.xyz")
		}
	}
}
