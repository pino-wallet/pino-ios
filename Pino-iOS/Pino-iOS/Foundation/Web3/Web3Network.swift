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
			return .pinoNode
		} else {
			return .arb
		}
	}

	public static var chainID: EthereumQuantity {
		.init(quantity: BigUInt(Environment.chainID))
	}

	public static var rpc: Web3 {
		Web3(rpcURL: Environment.rpcURL)
	}
}
