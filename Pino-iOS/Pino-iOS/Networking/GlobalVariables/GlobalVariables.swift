//
//  GlobalVariables.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/28/23.
//

import Foundation

class GlobalVariables {
	static let shared = GlobalVariables()

	@Published
	var ethGasFee = BigNumber(number: "0", decimal: 0)
	@Published
	var ethGasFeeInDollar = BigNumber(number: "0", decimal: 0)

	private init() {}
}
