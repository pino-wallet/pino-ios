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
	var ethGasFee = (fee: BigNumber(number: "0", decimal: 0), feeInDollar: BigNumber(number: "0", decimal: 0))

	private init() {}
}
