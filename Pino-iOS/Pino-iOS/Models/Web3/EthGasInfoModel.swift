//
//  EthGasInfoModel.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/23.
//

import Foundation

struct EthBaseFeeModelDetails {
	let baseFeeModel: EthGasInfoModel
	let isLoading: Bool
}

struct EthGasInfoModel: Codable {
	let baseFee, gasPrice: String

	enum CodingKeys: String, CodingKey {
		case baseFee = "base_fee"
		case gasPrice = "gas_price"
	}
}
