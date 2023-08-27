//
//  SelectInvestProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/27/23.
//

import Foundation

struct SelectInvestProtocolViewModel: SelectDexSystemVMProtocol {
	// MARK: - Public Properties

	public let dexSystemList: [DexSystemModel] = [.uniswap, .compound, .aave, .balancer]
	public let pageTitle = "Select protocol"
}
