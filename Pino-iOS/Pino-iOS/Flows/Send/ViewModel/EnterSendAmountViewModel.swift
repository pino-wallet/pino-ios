//
//  EnterSendAmountViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/11/23.
//

import Foundation

class EnterSendamountViewModel {
	// MARK: - Public Properties

	@Published
	public var selectedToken: AssetViewModel
	public var isDollarEnabled: Bool
	public let maxTitle = "Max: "
	public let dollarIcon = "dollar_icon"
	public let continueButtonTitle = "Next"

	public var textFieldPlaceHolder: String {
		if isDollarEnabled {
			return "$0.0"
		} else {
			return "0.0"
		}
	}

	public var maxAmount: String {
		selectedToken.amount
	}

	public var enteredAmount: String {
		if isDollarEnabled {
			return "0.0 \(selectedToken.symbol)"
		} else {
			return "$0.0"
		}
	}

	// MARK: - Initializers

	init(selectedToken: AssetViewModel, isDollarEnabled: Bool = false) {
		self.selectedToken = selectedToken
		self.isDollarEnabled = isDollarEnabled
	}
}
