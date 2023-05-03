//
//  AssetViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/21/22.
//
import BigInt
import Foundation

public class AssetViewModel: SecurityModeProtocol {
	// MARK: - Private Properties

	private var assetModel: AssetProtocol

	// MARK: - Public Properties

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

	public var holdAmountInDollorNumber: BigNumber {
		holdAmount * price
	}

	public var holdAmountInDollar: String {
		holdAmountInDollorNumber.formattedAmountOf(type: .price)
	}

	public var change24h: PriceNumberFormatter {
		PriceNumberFormatter(value: assetModel.detail!.change24H)
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: assetModel.detail!.change24H)
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
		"\(holdAmount.formattedAmountOf(type: .hold)) \(assetModel.detail!.symbol)"
	}

	private func getFormattedAmountInDollor() -> String {
		if holdAmount.isZero {
			return "-"
		} else {
			return "$\(holdAmountInDollar)"
		}
	}

	private func getFormattedVolatility() -> String {
		if change24h.bigNumber.isZero {
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
