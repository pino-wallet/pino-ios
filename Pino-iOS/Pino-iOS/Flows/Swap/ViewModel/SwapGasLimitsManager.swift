//
//  SwapGasLimitsManager.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/24/23.
//

import Foundation
import BigInt
import Web3

struct SwapGasLimitsManager {
    
    private var swapAmount: BigNumber
    private var gasLimitsModel: GasLimitsModel
    private var isEth: Bool
    private var provider: SwapProvider
    
    public var gasInfo: GasInfo {
        switch provider {
            case .oneInch:
                return getGasOf(provider: gasLimitsModel.oneInchSwaps)
            case .paraswap:
                return getGasOf(provider: gasLimitsModel.paraswapSwaps)
            case .zeroX:
                return getGasOf(provider: gasLimitsModel.zeroXSwaps)
        }
    }
    
    private func getGasOf(provider: GasLimitsModel.Swaps) -> GasInfo {
        if isEth {
            if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
                return .init(gasLimit: provider.ethBelow100000)
            } else if swapAmount >= 10000.bigNumber && swapAmount < 20000.bigNumber {
                return .init(gasLimit: provider.ethBelow200000)
            } else if swapAmount >= 20_000.bigNumber && swapAmount < 200_000.bigNumber {
                return .init(gasLimit: provider.ethBelow2000000)
            } else {
                return .init(gasLimit: provider.ethAbove2000000)
            }
        } else {
            if swapAmount > 0.bigNumber && swapAmount < 10000.bigNumber {
                return .init(gasLimit: provider.erc20Below10000)
            } else if swapAmount >= 10_000.bigNumber && swapAmount < 50_000.bigNumber {
                return .init(gasLimit: provider.erc20Below50000)
            } else if swapAmount >= 50_000.bigNumber && swapAmount < 100_000.bigNumber {
                return .init(gasLimit: provider.erc20Below100000)
            } else if swapAmount >= 100_000.bigNumber && swapAmount < 1_000_000.bigNumber {
                return .init(gasLimit: provider.erc20Below1000000)
            } else {
                return .init(gasLimit: provider.erc20Below1000000)
            }
        }
    }
}
