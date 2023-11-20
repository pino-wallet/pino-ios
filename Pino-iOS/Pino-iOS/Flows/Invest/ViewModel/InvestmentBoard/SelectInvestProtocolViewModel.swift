//
//  SelectInvestProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/27/23.
//

import Foundation

struct SelectInvestProtocolViewModel: SelectDexSystemVMProtocol {
	// MARK: - Public Properties

	public let dexSystemList: [InvestProtocolViewModel] = [.maker, .compound, .lido, .aave]
	public let pageTitle = "Select protocol"
}
