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

	public let gasLimit: BigNumber?
	public let priorityFeePerGas = BigNumber(number: "1000000000", decimal: 0) // in Wei

	public var baseFee: BigNumber {
		.init(number: GlobalVariables.shared.ethGasFee!.baseFeeModel.baseFee, decimal: 0)
	}

	public var gasPrice: BigNumber {
		.init(number: GlobalVariables.shared.ethGasFee!.baseFeeModel.gasPrice, decimal: 0)
	}

	public var maxFeePerGas: BigNumber {
		(baseFee * 2.bigNumber) + priorityFeePerGas
	}

	public var increasedGasLimit: BigNumber? {
		guard let gasLimit else { return nil }
		let increased = try! EthereumQuantity((gasLimit.bigUInt * BigUInt(105)) / BigUInt(100)).quantity
		return BigNumber(unSignedNumber: increased, decimal: 0)
	}

	public var increasedBaseFee: BigNumber {
		let increased = try! EthereumQuantity((baseFee.bigUInt * BigUInt(120)) / BigUInt(100)).quantity
		return BigNumber(unSignedNumber: increased, decimal: 0)
	}

	public var baseFeeWithPriorityFee: BigNumber {
		BigNumber(number: increasedBaseFee + priorityFeePerGas, decimal: 0)
	}

	public var fee: BigNumber? {
		guard let increasedGasLimit else { return nil }
		return BigNumber(number: (increasedBaseFee + priorityFeePerGas) * increasedGasLimit, decimal: 18)
	}

	public var feeInDollar: BigNumber? {
		guard let fee else { return nil }
		let eth = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth })
		return fee * eth!.price
	}

	public init(gasLimit: EthereumQuantity) {
		self.gasLimit = BigNumber(unSignedNumber: gasLimit.quantity, decimal: 0)
	}

	public init(gasLimit: String) {
		self.gasLimit = BigNumber(number: gasLimit, decimal: 0)
	}

	public init(gasLimit: BigNumber) {
		self.gasLimit = BigNumber(number: gasLimit, decimal: 0)
	}

	// This init for gas estimation phase
	public init() {
		self.gasLimit = nil
	}
}
