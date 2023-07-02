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
	public var selectedTokenChanged: (() -> Void)!
	public var amountUpdated: ((String) -> Void)!
	public var swapAmountCalculated: ((String) -> Void)!
	public var textFieldPlaceHolder = "0.0"
	public var isEditing = false

	public var selectedToken: AssetViewModel

	public var maxHoldAmount: String {
		selectedToken.amount
	}

	@Published
	public var tokenAmount = ""
	public var dollarAmount = "0"
	public var decimalDollarAmount: Decimal?

	public var formattedAmount: String {
		"\(avgSign) $\(dollarAmount)"
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}

	// MARK: - Public Methods

	public func calculateAmount(_ amount: String) {
		if let decimalNumber = Decimal(string: amount), let price = Decimal(string: selectedToken.price.decimalString) {
			decimalDollarAmount = decimalNumber * price
			dollarAmount = decimalDollarAmount!.formattedAmount(type: .dollarValue)
		} else {
			decimalDollarAmount = nil
			dollarAmount = "0"
		}
		tokenAmount = amount
	}
}
