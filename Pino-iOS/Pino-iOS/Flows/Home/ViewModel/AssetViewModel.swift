//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import Foundation
import BigInt

public class AssetViewModel: SecurityModeProtocol {
	// MARK: - Private Properties

	private var assetModel: AssetProtocol!

	// MARK: - Public Properties

	public var securityMode = false

	public var id: String {
		assetModel.id
	}

	public var image: URL {
		URL(string: assetModel.detail!.logo)!
	}

	public var name: String {
		assetModel.detail!.name
	}
    
    public var hold: BigInt {
        BigInt(assetModel.hold)!
    }
    
    public var price: BigInt {
        BigInt(assetModel.detail!.price)!
    }

    public var decimal: Int {
        assetModel.detail!.decimals
    }

    public var holdAmount: BigInt {
        print(hold / BigInt(10).power(assetModel.detail!.decimals))
        
        let devideBy = BigInt(10).power(assetModel.detail!.decimals)
        let result = hold.quotientAndRemainder(dividingBy: devideBy)
        print(result)
        
        return hold / BigInt(10).power(assetModel.detail!.decimals)
    }
    
    public var holdAmountInDollar: BigInt {
        holdAmount * price
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
        return "\(PercisionCalculate.trimmedValueOf(coin: holdAmount)) \(assetModel.detail!.symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
        if hold.isZero {
			return "-"
		} else {
			return "$\(holdAmountInDollar)"
		}
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
