//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

public class AssetViewModel: SecurityModeProtocol {
	// MARK: - Public Properties

	public var assetModel: AssetModel!
	public var securityMode = false

	public var image: String {
		assetModel.image
	}

	public var name: String {
		assetModel.name
	}

	public var amount: String
	public var amountInDollor: String
	public var volatilityInDollor: String

	public var volatilityType: AssetVolatilityType {
		if let volatilityType = assetModel.volatilityType {
			return volatilityType
		} else {
			return .none
		}
	}

	// MARK: - Initializers

	init(assetModel: AssetModel) {
		self.assetModel = assetModel

		let amount = assetModel.amount ?? "0"
		self.amount = "\(amount) \(assetModel.codeName)"

		if let amountInDollor = assetModel.amountInDollor {
			self.amountInDollor = "$\(amountInDollor)"
		} else {
			self.amountInDollor = "-"
		}

		if let volatility = assetModel.volatilityInDollor {
			let volatilityType = assetModel.volatilityType ?? .none
			switch volatilityType {
			case .loss:
				self.volatilityInDollor = "-$\(volatility)"
			case .profit, .none:
				self.volatilityInDollor = "+$\(volatility)"
			}
		} else {
			self.volatilityInDollor = "-"
		}
	}

	// MARK: - Public Methods

	public func enableSecurityMode() {
		securityMode = true
		amount = securityText
		amountInDollor = securityText
		volatilityInDollor = securityText
	}

	public func disableSecurityMode() {
		securityMode = false
		amount = getFormattedAmount()
		amountInDollor = getFormattedAmountInDollor()
		volatilityInDollor = getFormattedVolatility()
	}

	// MARK: - Private Methods

	private func getFormattedAmount() -> String {
		let amount = assetModel.amount ?? "0"
		return "\(amount) \(assetModel.codeName)"
	}

	private func getFormattedAmountInDollor() -> String {
		if let amountInDollor = assetModel.amountInDollor {
			return "$\(amountInDollor)"
		} else {
			return "-"
		}
	}

	private func getFormattedVolatility() -> String {
		if let volatility = assetModel.volatilityInDollor {
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
}
