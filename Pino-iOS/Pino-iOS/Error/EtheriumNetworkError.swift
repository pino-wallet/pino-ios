//
//  EtheriumNetworkError.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/30/24.
//

import Foundation
import Web3

enum EtheriumNetworkError {
	case estimationFailed
	case unknown

	public var toastMessage: String {
		switch self {
		case .estimationFailed:
			"Failed to estimate gas"
		case .unknown:
			"Something went wrong"
		}
	}

	init(error: RPCResponse<EthereumQuantity>.Error) {
		if error.code == -32000 {
			self = .estimationFailed
		} else {
			self = .unknown
		}
	}
}
