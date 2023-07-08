//
//  SwapProtocolModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import Foundation

struct SwapProtocolModel {
	// MARK: - Public Properties

	public var name: String
	public var image: String
	public var description: String

	// MARK: - Initializers

	private init(name: String, image: String, description: String) {
		self.name = name
		self.image = image
		self.description = description
	}
}

extension SwapProtocolModel {
	// MARK: - Public Properties

	public static var bestRate = SwapProtocolModel(
		name: "Best rate",
		image: "best_rate_protocol",
		description: "Find the best rate"
	)

	public static var uniswap = SwapProtocolModel(
		name: "Uniswap",
		image: "uniswap_protocol",
		description: "uniswap.org"
	)

	public static var curve = SwapProtocolModel(
		name: "Curve",
		image: "curve_protocol",
		description: "curve.fi"
	)

	public static var balancer = SwapProtocolModel(
		name: "Balancer",
		image: "balancer_protocol",
		description: "balancer.fi"
	)
}
