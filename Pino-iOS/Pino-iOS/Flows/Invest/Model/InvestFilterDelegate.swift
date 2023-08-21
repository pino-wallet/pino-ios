//
//  InvestFilterDelegate.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

protocol InvestFilterDelegate {
	var assetFilter: AssetViewModel? { get }
	var protocolFilter: InvestProtocolViewModel? { get }
	var riskFilter: String? { get }

	func filterUpdated(
		assetFilter: AssetViewModel?,
		protocolFilter: InvestProtocolViewModel?,
		riskFilter: String?
	)
}
