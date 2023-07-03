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
	public let switchIcon = "switch_swap"

	public var fromToken: SwapTokenViewModel
	public var toToken: SwapTokenViewModel

	// MARK: - Initializers

	init(fromToken: AssetViewModel, toToken: AssetViewModel) {
		self.fromToken = SwapTokenViewModel(selectedToken: fromToken)
		self.toToken = SwapTokenViewModel(selectedToken: toToken)

		self.fromToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
		self.toToken.amountUpdated = { amount in
			self.recalculateTokensAmount(amount: amount)
		}
	}

	// MARK: - Private Methods

	private func recalculateTokensAmount(amount: String? = nil) {}

	// MARK: - Public Methods

	public func changeSelectedToken(_ token: SwapTokenViewModel, to newToken: AssetViewModel) {}

	public func switchTokens() {}
}
