//
//  SwapProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import Foundation

struct SwapProtocol {
	public var name: String
	public var image: String
	public var description: String

	public static var bestRate = SwapProtocol(
		name: "Best rate",
		image: "best_rate_protocol",
		description: "Find the best rate"
	)

	public static var uniswap = SwapProtocol(
		name: "Uniswap",
		image: "uniswap_protocol",
		description: "uniswap.org"
	)

	public static var curve = SwapProtocol(
		name: "Curve",
		image: "curve_protocol",
		description: "curve.fi"
	)

	public static var balancer = SwapProtocol(
		name: "Balancer",
		image: "balancer_protocol",
		description: "balancer.fi"
	)
}
