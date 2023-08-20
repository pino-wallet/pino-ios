//
//  SelectSwapProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import Foundation

class SelectSwapProtocolViewModel: SelectDexProtocolVMProtocol {
	// MARK: - Public Properties

	public let pageTitle = "Select DEX"
	public let dissmissIocn = "dissmiss"

	public var dexProtocolsList: [dexProtocolModel] = [.bestRate, .balancer, .uniswap, .curve]
}
