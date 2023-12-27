//
//  GasLimitsModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 12/24/23.
//

import Foundation

// MARK: - GasLimitsModel

struct GasLimitsModel: Codable {
	let sendErc20: String
	let oneInchSwaps, zeroXSwaps, paraswapSwaps: Swaps
	let aave: Aave
	let invest: Invest
	let compound: Compound

	enum CodingKeys: String, CodingKey {
		case sendErc20 = "send_erc20"
		case oneInchSwaps = "one_inch_swaps"
		case zeroXSwaps = "zero_x_swaps"
		case paraswapSwaps = "paraswap_swaps"
		case aave, invest, compound
	}

	// MARK: - Aave

	struct Aave: Codable {
		let deposit, depositErc20, withdraw, withdrawErc20: String
		let borrow, repay: String

		enum CodingKeys: String, CodingKey {
			case deposit
			case depositErc20 = "deposit_erc20"
			case withdraw
			case withdrawErc20 = "withdraw_erc20"
			case borrow, repay
		}
	}

	// MARK: - Compound

	struct Compound: Codable {
		let deposit, depositWeth, repayEth, repay: String
		let withdrawEth, withdraw: String

		enum CodingKeys: String, CodingKey {
			case deposit
			case depositWeth = "deposit_weth"
			case repayEth = "repay_eth"
			case repay
			case withdrawEth = "withdraw_eth"
			case withdraw
		}
	}

	// MARK: - Invest

	struct Invest: Codable {
		let ethToStEth, wethToStEth, daiToSdai, sdaiToDai: String

		enum CodingKeys: String, CodingKey {
			case ethToStEth = "eth_to_st_eth"
			case wethToStEth = "weth_to_st_eth"
			case daiToSdai = "dai_to_sdai"
			case sdaiToDai = "sdai_to_dai"
		}
	}

	// MARK: - Swaps

	struct Swaps: Codable {
		let ethBelow100000, ethBelow200000, ethBelow2000000, ethAbove2000000: String
		let erc20Below10000, erc20Below50000, erc20Below100000, erc20Below1000000: String
		let erc20Above1000000: String

		enum CodingKeys: String, CodingKey {
			case ethBelow100000 = "eth_below_100000"
			case ethBelow200000 = "eth_below_200000"
			case ethBelow2000000 = "eth_below_2000000"
			case ethAbove2000000 = "eth_above_2000000"
			case erc20Below10000 = "erc20_below_10000"
			case erc20Below50000 = "erc20_below_50000"
			case erc20Below100000 = "erc20_below_100000"
			case erc20Below1000000 = "erc20_below_1000000"
			case erc20Above1000000 = "erc20_above_1000000"
		}
	}
}
