//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import BigInt
import Foundation
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

	public var price: PriceNumberFormatter {
		PriceNumberFormatter(value: assetModel.detail!.price)
	}

	public var decimal: Int {
		assetModel.detail!.decimals
	}

	public var holdAmount: HoldNumberFormatter {
		HoldNumberFormatter(value: assetModel.hold, decimal: decimal)
	}

	public var holdAmountInDollar: String {
		let amount = holdAmount.formattedDoubleValue * price.formattedDoubleValue
		return NumberPercisionFormatter.trimmedValueOf(money: amount)
	}

    public var change24h: PriceNumberFormatter {
        PriceNumberFormatter(value: assetModel.detail!.change24H)
    }
    
	public var amount = "0"
	public var amountInDollor = "-"
	public var volatilityInDollor = "-"

	public var volatilityType: AssetVolatilityType {
        if change24h.doubleValue.isZero {
			return .none
		} else {
            switch change24h.doubleValue.sign {
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
		"\(holdAmount.formattedAmount) \(assetModel.detail!.symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
		if holdAmount.bigValue.isZero {
			return "-"
		} else {
			return "$\(holdAmountInDollar)"
		}
	}

	private func getFormattedVolatility() -> String {
        if change24h.formattedDoubleValue.isZero {
			return "-"
		} else {
			switch volatilityType {
			case .loss:
                var lossValue = change24h.formattedAmount
                lossValue.removeFirst()
				return "-$\(lossValue)"
			case .profit, .none:
                return "+$\(change24h.formattedAmount)"
			}
		}
	}
}
