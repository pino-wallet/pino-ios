//
//  SwapGasLimitsManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/24/23.
//

import BigInt
import Foundation
import Web3

struct SwapGasLimitsManager {
	// MARK: - Private Properties

	private var swapAmount: BigNumber
	private var gasLimitsModel: GasLimitsModel
	private var isEth: Bool
	private var provider: SwapProvider

	private var gasInfo: GasInfo {
		switch provider {
		case .oneInch:
			return getGasOf(provider: gasLimitsModel.oneInchSwaps)
		case .paraswap:
			return getGasOf(provider: gasLimitsModel.paraswapSwaps)
		case .zeroX:
			return getGasOf(provider: gasLimitsModel.zeroXSwaps)
		}
	}

	// MARK: - Private Initializer

	private init(swapAmount: BigNumber, gasLimitsModel: GasLimitsModel, isEth: Bool, provider: SwapProvider) {
		self.swapAmount = swapAmount
		self.gasLimitsModel = gasLimitsModel
		self.isEth = isEth
		self.provider = provider
	}

	// MARK: - Public Methods

	public static func getMaxAmount(selectedToken: AssetViewModel) -> BigNumber {
		if selectedToken.isEth {
			let gasLimits: GasLimitsModel? = UserDefaultsManager.gasLimits.getValue()
			if let gasLimits {
				let maxEthAmount = selectedToken.holdAmountInDollor
				let gasLimitsManager = SwapGasLimitsManager(
					swapAmount: maxEthAmount,
					gasLimitsModel: gasLimits,
					isEth: true,
					provider: .paraswap
				)
				let maxAmount = selectedToken.holdAmount - gasLimitsManager.medianGasInfo.fee!
				if maxAmount.number > 0 {
					return maxAmount
				} else {
					return 0.bigNumber
				}
			} else {
				return selectedToken.holdAmount
			}
		} else {
			return selectedToken.holdAmount
		}
	}

	// MARK: - Private Methods

	private func getGasOf(provider: GasLimitsModel.Swaps) -> GasInfo {
		if isEth {
			if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
				return .init(gasLimit: provider.ethBelow100000)
			} else if swapAmount >= 10000.bigNumber && swapAmount < 20000.bigNumber {
				return .init(gasLimit: provider.ethBelow200000)
			} else if swapAmount >= 20000.bigNumber && swapAmount < 200_000.bigNumber {
				return .init(gasLimit: provider.ethBelow2000000)
			} else {
				return .init(gasLimit: provider.ethAbove2000000)
			}
		} else {
			if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
				return .init(gasLimit: provider.erc20Below10000)
			} else if swapAmount >= 10000.bigNumber && swapAmount < 50000.bigNumber {
				return .init(gasLimit: provider.erc20Below50000)
			} else if swapAmount >= 50000.bigNumber && swapAmount < 100_000.bigNumber {
				return .init(gasLimit: provider.erc20Below100000)
			} else if swapAmount >= 100_000.bigNumber && swapAmount < 1_000_000.bigNumber {
				return .init(gasLimit: provider.erc20Below1000000)
			} else {
				return .init(gasLimit: provider.erc20Above1000000)
			}
		}
	}

	public var medianGasInfo: GasInfo {
		if isEth {
			if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.ethBelow100000))
			} else if swapAmount >= 10000.bigNumber && swapAmount < 20000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.ethBelow200000))
			} else if swapAmount >= 20000.bigNumber && swapAmount < 200_000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.ethBelow2000000))
			} else {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.ethAbove2000000))
			}
		} else {
			if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.erc20Below10000))
			} else if swapAmount >= 10000.bigNumber && swapAmount < 50000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.erc20Below50000))
			} else if swapAmount >= 50000.bigNumber && swapAmount < 100_000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.erc20Below100000))
			} else if swapAmount >= 100_000.bigNumber && swapAmount < 1_000_000.bigNumber {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.erc20Below1000000))
			} else {
				return .init(gasLimit: calculateMedianOfProvidersGas(range: \.erc20Above1000000))
			}
		}
	}

	private func calculateMedianOfProvidersGas(range: KeyPath<GasLimitsModel.Swaps, String>) -> String {
		let paraswapProv = gasLimitsModel.paraswapSwaps
		let oneInchProv = gasLimitsModel.oneInchSwaps
		let zeroxProv = gasLimitsModel.zeroXSwaps
		let median = (
			paraswapProv[keyPath: range].doubleValue! + oneInchProv[keyPath: range]
				.doubleValue! + zeroxProv[keyPath: range].doubleValue!
		) / 3
		return Int(median).description
	}
}
