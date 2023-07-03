//
//  SwapTokenViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation

class SwapTokenViewModel {
	// MARK: - Public Properties

	public var selectedToken: AssetViewModel
	public var amountUpdated: ((String) -> Void)!

	// MARK: - Initializers

	init(selectedToken: AssetViewModel) {
		self.selectedToken = selectedToken
	}
}
