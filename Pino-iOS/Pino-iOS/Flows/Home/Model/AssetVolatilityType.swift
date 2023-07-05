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

    init(change24h: BigNumber) {
        if change24h.number.isZero {
            self = .none
        } else {
            switch change24h.number.sign {
            case .minus:
                self = .loss
            case .plus:
                self = .profit
            }
        }
        self = .profit
    }

	public var prependSign: String {
		switch self {
		case .profit:
			return "+"
		case .loss:
			return "-"
		case .none:
			return ""
		}
	}
}
