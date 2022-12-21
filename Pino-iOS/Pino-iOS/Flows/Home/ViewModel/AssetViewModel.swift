//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

public struct AssetViewModel {
	// MARK: - Public Properties

	public var assetModel: AssetModel!

	public var image: String {
		assetModel.image
	}

	public var name: String {
		assetModel.name
	}

	public var amount: String {
		if let amount = assetModel.amount {
			return "\(amount) \(assetModel.codeName)"
		} else {
			return "0 \(assetModel.codeName)"
		}
	}

	public var amountInDollor: String {
		if let amountInDollor = assetModel.amountInDollor {
			return "$\(amountInDollor)"
		} else {
			return "-"
		}
	}

	public var volatility: String {
		if let volatility = assetModel.volatility {
			switch volatilityType {
			case .loss:
				return "-$\(volatility)"
			case .profit, .none:
				return "+$\(volatility)"
			}
		} else {
			return "-"
		}
	}

	public var volatilityType: AssetVolatilityType {
		if let volatilityType = assetModel.volatilityType {
			return volatilityType
		} else {
			return .none
		}
	}
}
