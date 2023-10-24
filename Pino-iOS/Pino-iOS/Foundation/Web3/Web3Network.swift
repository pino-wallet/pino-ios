//
//  Web3Network.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 10/22/23.
//

import Foundation
import Web3

public enum Web3Network: String {
	case mainNet
	case arb
	case ganashDev

	// MARK: - Public Properties

	public var current: Self {
		if Environment.current == .mainNet {
			return .mainNet
		} else if Environment.current == .devNet {
			return .ganashDev
		} else {
			return .arb
		}
	}

	public static var chainID: EthereumQuantity {
		try! .init(Environment.chainID)
	}

	public static var rpcUrl: String {
		Environment.rpcURL
	}
}
