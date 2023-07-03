//
//  SwapViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation

class SwapViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Swap"
	public let continueButtonTitle = "Swap"
	public let insufficientAmountButtonTitle = "Insufficient amount"

	public var payToken: SwapTokenViewModel
	public var getToken: SwapTokenViewModel

	// MARK: - Initializers

	init(payToken: AssetViewModel, getToken: AssetViewModel) {
		self.payToken = SwapTokenViewModel(selectedToken: payToken)
		self.getToken = SwapTokenViewModel(selectedToken: getToken)

		self.payToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.getToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String? = nil) {}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {}

	public func switchTokens() {}
}
