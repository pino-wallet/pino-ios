//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import Foundation
import BigInt
import Web3Core

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
    
    public var price: Double {
        
        let bigPrice = BigInt(assetModel.detail!.price)!
        let amount = Utilities.formatToPrecision(bigPrice, units: .custom(6), formattingDecimals: 2, decimalSeparator: ".", fallbackToScientific: false)

        return amount.doubleValue!
    }

    public var decimal: Int {
        assetModel.detail!.decimals
    }
    
    public var change24h: BigInt {
        BigInt(assetModel.detail!.change24H)!
    }

    public var holdAmount: Double {
                
        let amount = Utilities.formatToPrecision(hold, units: .custom(assetModel.detail!.decimals), formattingDecimals: 6, decimalSeparator: ".", fallbackToScientific: true)
            
        return Double(amount)!
    }
    
    public var holdAmountInDollar: String {
        print("\(name)")
        print("Big:\(holdAmount) | \(BigInt(holdAmount))")
        print("BigPrice:\(price) | \(BigInt(price))")
        print("BigxBigPrice:\(BigInt(holdAmount) * BigInt(price))")
        print("---------------------------------------")

        let amount = holdAmount * price
        
        return PercisionCalculate.trimmedValueOf(money: amount)
    }
    
    
	public var amount = "0"
	public var amountInDollor = "-"
	public var volatilityInDollor = "-"

	public var volatilityType: AssetVolatilityType {
        if change24h.isZero {
            return .none
        } else {
            switch change24h.sign {
            case .minus:
                return .loss
            case .plus:
                return .profit
            }
        }
        
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
        return "\(holdAmount) \(assetModel.detail!.symbol)"
//        return "\(PercisionCalculate.trimmedValueOf(coin: holdAmount)) \(assetModel.detail!.symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
        if hold.isZero {
			return "-"
		} else {
			return "$\(holdAmountInDollar)"
		}
    }

    public var volatilityDollorValue: String {
        let volaitility = BigInt(assetModel.detail!.change24H)!
        let amount = Utilities.formatToPrecision(volaitility, units: .custom(6), formattingDecimals: 2, decimalSeparator: ".", fallbackToScientific: false)
        return amount
    }
    
	private func getFormattedVolatility() -> String {
        if change24h.isZero {
			return "-"
		} else {
			switch volatilityType {
			case .loss:
                var lossValue = volatilityDollorValue
                lossValue.removeFirst()
                return "-$\(lossValue)"
			case .profit, .none:
				return "+$\(volatilityDollorValue)"
			}
		}
	}
}
