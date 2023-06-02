//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import BigInt
import Foundation

public class AssetViewModel: SecurityModeProtocol {
	// MARK: - Public Properties

	public var assetModel: AssetProtocol

	public var securityMode = false
	public var isSelected: Bool
	public var amount = "0"
	public var amountInDollor = "-"
	public var volatilityInDollor = "-"

	public var id: String {
		assetModel.id
	}

	public var image: URL {
		URL(string: assetModel.detail!.logo)!
	}

	public var name: String {
		assetModel.detail!.name
	}

	public var price: BigNumber {
		BigNumber(number: assetModel.detail!.price, decimal: 6)
	}

	public var decimal: Int {
		assetModel.detail!.decimals
	}

	public var holdAmount: BigNumber {
		BigNumber(number: assetModel.amount, decimal: decimal)
	}

	public var holdAmountInDollor: BigNumber {
		holdAmount * price
	}

	public var formattedHoldAmount: String {
		holdAmountInDollor.formattedAmountOf(type: .price)
	}

	public var change24h: BigNumber {
		holdAmountInDollor - previousDayNetworth
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: change24h.description)
	}

	public var symbol: String {
		assetModel.detail!.symbol
	}

	public var previousDayNetworth: BigNumber {
		BigNumber(number: assetModel.previousDayNetworth, decimal: 2)
	}

	// MARK: - Initializers

	init(assetModel: AssetProtocol, isSelected: Bool) {
		self.assetModel = assetModel
		self.isSelected = isSelected
		self.amount = getFormattedAmount()
		self.amountInDollor = getFormattedAmountInDollor()
		self.volatilityInDollor = getFormattedVolatility()
	}

	// MARK: - Public Methods

	public func switchSecurityMode(_ isOn: Bool) {
		if isOn {
			securityMode = true
			amount = securityText
			amountInDollor = securityText
			volatilityInDollor = securityText
		} else {
			securityMode = false
			amount = getFormattedAmount()
			amountInDollor = getFormattedAmountInDollor()
			volatilityInDollor = getFormattedVolatility()
		}
	}

	public func toggleIsSelected() {
		isSelected.toggle()
	}

	// MARK: - Private Methods

	private func getFormattedAmount() -> String {
		"\(holdAmount.formattedAmountOf(type: .hold)) \(symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
		if holdAmount.isZero {
			return "-"
		} else {
			return "$\(formattedHoldAmount)"
		}
	}

	private func getFormattedVolatility() -> String {
		if change24h.isZero {
			return "-"
		} else {
			switch volatilityType {
			case .loss:
				var lossValue = change24h.formattedAmountOf(type: .price)
                return "-$\(lossValue)"
			case .profit, .none:
				return "+$\(change24h.formattedAmountOf(type: .price))"
			}
		}
	}
}
