//
//  SwapTokenViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/1/23.
//

import Foundation

class SwapTokenViewModel {
	// MARK: - Public Properties

	public let maxTitle = "Max: "
	public let avgSign = "≈"
	public var selectedTokenChanged: (() -> Void)?
	public var textFieldPlaceHolder = "0.0"

	public var selectedToken: AssetViewModel {
		didSet {
			if let selectedTokenChanged {
				selectedTokenChanged()
			}
		}
	}

	public var maxHoldAmount: String {
		selectedToken.amount
	}

	public var tokenAmount = "0.0"
	public var dollarAmount = "0.0"

	public var formattedAmount: String {
		"\(avgSign) $\(dollarAmount)"
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}

	// MARK: - Public Methods

	public func calculateAmount(_ amount: String) {
		guard let price = Decimal(string: selectedToken.price.decimalString) else { return }
		let decimalNumber = Decimal(string: amount) ?? Decimal(0)
		let amountInDollarDecimalValue = decimalNumber * price
		dollarAmount = amountInDollarDecimalValue.formattedAmount(type: .dollarValue)
		tokenAmount = amount
	}
}
