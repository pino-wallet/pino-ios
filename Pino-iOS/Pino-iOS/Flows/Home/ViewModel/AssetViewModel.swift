//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//

public class AssetViewModel: SecurityModeProtocol {
	// MARK: - Private Properties

	private var assetModel: AssetProtocol!

	// MARK: - Public Properties

	public var securityMode = false

	public var id: String {
		assetModel.id
	}

	public var image: String {
		assetModel.detail!.logo
	}

	public var name: String {
		assetModel.detail!.name
	}

	public var amount = "0"
	public var amountInDollor = "-"
	public var volatilityInDollor = "-"

	public var volatilityType: AssetVolatilityType {
//		AssetVolatilityType(rawValue: assetModel.volatilityType) ?? .none
		.profit
	}

	public var isSelected = true

	// MARK: - Initializers

	init(assetModel: AssetProtocol) {
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

	public func toggleIsSelected() {
		isSelected.toggle()
	}

	// MARK: - Private Methods

	private func getFormattedAmount() -> String {
		"\(assetModel.hold) \(assetModel.detail!.symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
//		if Int(assetModel.detail!.price) == 0 {
//			return "-"
//		} else {
//			return "$\(assetModel.detail!.price)"
//		}
        let temp = [0.343534534,12.343534534,124.343534534,1263.343534534,12634.343534534,126345.343534534]
        let holdAmmount = PercisionCalculate.trimmedValueOf(coin: temp.randomElement()!)
		return "$\(holdAmmount)"
	}

	private func getFormattedVolatility() -> String {
		"+$3.5"
//		if Int(assetModel.volatilityInDollor) == 0 {
//			return "-"
//		} else {
//			switch volatilityType {
//			case .loss:
//				return "-$\(assetModel.volatilityInDollor)"
//			case .profit, .none:
//				return "+$\(assetModel.volatilityInDollor)"
//			}
//		}
	}
}
