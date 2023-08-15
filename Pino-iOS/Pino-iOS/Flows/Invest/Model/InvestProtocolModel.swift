//
//  InvestProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation

public struct InvestProtocolModel {
	// MARK: - Public Properties

	public let name: String
	public let image: String
	public let description: String
}

extension InvestProtocolModel {
	// MARK: - Public Properties

	public static var uniswap = InvestProtocolModel(
		name: "Uniswap",
		image: "uniswap_protocol",
		description: "uniswap.org"
	)

	public static var compound = InvestProtocolModel(
		name: "Compound",
		image: "compound_protocol",
		description: "compound.io"
	)
	public static var aave = InvestProtocolModel(
		name: "Aave",
		image: "aave_protocol",
		description: "aave.io"
	)

	public static var balancer = InvestProtocolModel(
		name: "Balancer",
		image: "balancer_protocol",
		description: "balancer.fi"
	)
}
