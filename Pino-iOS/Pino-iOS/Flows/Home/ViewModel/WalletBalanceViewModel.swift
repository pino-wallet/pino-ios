//
//  WalletBalanceViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

struct WalletBalanceViewModel {
	// MARK: - Public Properties

	public var balanceModel: WalletBalanceModel!

	public let securityModeText = "••••••"
	public let showBalanceButtonTitle = "Show balance"
	public let showBalanceButtonImage = "eye"
	public var securityMode = false

	public var balance: String {
		if securityMode {
			return securityModeText
		} else if let balance = balanceModel.balance {
			return "$\(balance)"
		} else {
			return "$0.0"
		}
	}

	public var volatilityPercentage: String {
		if let volatility = balanceModel.volatilityPercentage {
			switch volatilityType {
			case .profit:
				return "+\(volatility)%"
			case .loss:
				return "-\(volatility)%"
			case .none:
				return "\(volatility)%"
			}
		} else {
			return "0.0%"
		}
	}

	public var volatilityInDollor: String {
		if let volatility = balanceModel.volatilityInDollor {
			switch volatilityType {
			case .profit:
				return "+$\(volatility)"
			case .loss:
				return "-$\(volatility)"
			case .none:
				return "$\(volatility)"
			}
		} else {
			return "$0.0"
		}
	}

	public var volatilityType: AssetVolatilityType {
		if let volatilityType = balanceModel.volatilityType {
			return volatilityType
		} else {
			return .none
		}
	}
}
