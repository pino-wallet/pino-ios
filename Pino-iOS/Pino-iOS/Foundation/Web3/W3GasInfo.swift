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

	public var increasedGasLimit: BigUInt {
		try! EthereumQuantity((gasLimit * BigUInt(110)) / BigUInt(100)).quantity
	}

	public var fee: BigUInt {
		increasedGasLimit * gasPrice
	}

	public var feeInDollar: BigNumber {
		let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
		let fee = BigNumber(unSignedNumber: fee, decimal: 18)
		return fee * eth!.price
	}
}
