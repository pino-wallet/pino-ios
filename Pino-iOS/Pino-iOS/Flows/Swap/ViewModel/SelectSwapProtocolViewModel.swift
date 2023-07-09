//
//  SelectSwapProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import Foundation

class SelectSwapProtocolViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Select DEX"
	public let dissmissIocn = "dissmiss"

	public var swapProtocols: [SwapProtocolModel]

	// MARK: - initializers

	init() {
		self.swapProtocols = [.bestRate, .uniswap, .curve, .balancer]
	}
}
