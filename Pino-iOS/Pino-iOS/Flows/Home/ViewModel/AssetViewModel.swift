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

	public var amount = "0"
	public var amountInDollor = "-"
	public var volatilityInDollor = "-"

	public var volatilityType: AssetVolatilityType {
		assetModel.volatilityType
	}

	// MARK: - Initializers

	init(assetModel: AssetModel) {
		self.assetModel = assetModel
		self.amount = getFormattedAmount()
		self.amountInDollor = getFormattedAmountInDollor()
		self.volatilityInDollor = getFormattedVolatility()
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
		"\(assetModel.amount) \(assetModel.codeName)"
	}

	private func getFormattedAmountInDollor() -> String {
		if Int(assetModel.amountInDollor) == 0 {
			return "-"
		} else {
			return "$\(assetModel.amountInDollor)"
		}
	}

	private func getFormattedVolatility() -> String {
		if Int(assetModel.volatilityInDollor) == 0 {
			return "-"
		} else {
			switch volatilityType {
			case .loss:
				return "-$\(assetModel.volatilityInDollor)"
			case .profit, .none:
				return "+$\(assetModel.volatilityInDollor)"
			}
		}
	}
}
