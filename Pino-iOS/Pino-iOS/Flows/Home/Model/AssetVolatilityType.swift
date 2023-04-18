//
//  AssetVolatilityType.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

public enum AssetVolatilityType: String, Codable {
	case profit
	case loss
	case none
}

public func calculateAssetVolatilityType(change24h: String) -> AssetVolatilityType {
	let change24hInt = PriceNumberFormatter(value: change24h)
	if change24hInt.bigNumber.isZero {
		return .none
	} else {
		switch change24hInt.bigNumber.number.sign {
		case .minus:
			return .loss
		case .plus:
			return .profit
		}
	}
}
