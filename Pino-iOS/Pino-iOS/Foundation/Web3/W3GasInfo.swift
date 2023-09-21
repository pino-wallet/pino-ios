//
//  W3GasInfo.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 8/19/23.
//

import BigInt
import Foundation
import Web3

public struct GasInfo {
	// MARK: - Public Properties

	public let gasPrice: BigUInt
	public let gasLimit: BigNumber

	public var increasedGasLimit: BigNumber {
        let increased = try! EthereumQuantity((gasLimit.bigUInt * BigUInt(120)) / BigUInt(100)).quantity
		return BigNumber(unSignedNumber: increased, decimal: 0)
	}

	public var fee: BigNumber {
		let gasPrice = BigNumber(unSignedNumber: gasPrice, decimal: 0)
		return BigNumber(number: increasedGasLimit * gasPrice, decimal: 18)
	}

	public var feeInDollar: BigNumber {
		let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
		return fee * eth!.price
	}
}
