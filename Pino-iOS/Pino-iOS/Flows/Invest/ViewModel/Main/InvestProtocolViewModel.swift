//
//  InvestProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation

public struct InvestProtocolViewModel {
	public let type: InvestProtocol

	public var protocolInfo: InvestProtocolModel {
		switch type {
		case .uniswap:
			return InvestProtocolModel.uniswap
		case .compound:
			return InvestProtocolModel.compound
		case .aave:
			return InvestProtocolModel.aave
		case .balancer:
			return InvestProtocolModel.balancer
		}
	}

	init(name: String) {
		self.type = InvestProtocol(rawValue: name)!
	}

	public enum InvestProtocol: String {
		case uniswap = "Uniswap"
		case compound = "Compound"
		case aave = "Aave"
		case balancer = "Balancer"
	}
}
