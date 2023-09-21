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
	public let gasLimit: BigUInt

	public var increasedGasLimit: BigNumber {
		let increased = try! EthereumQuantity((gasLimit * BigUInt(120)) / BigUInt(100)).quantity
		return BigNumber(unSignedNumber: increased, decimal: 18)
	}

	public var fee: BigNumber {
		let gasLimit = BigNumber(unSignedNumber: gasLimit, decimal: 18)
		let gasPrice = BigNumber(unSignedNumber: gasPrice, decimal: 18)
		return gasLimit * gasPrice
	}

	public var feeInDollar: BigNumber {
		let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
		return fee * eth!.price
	}
}
