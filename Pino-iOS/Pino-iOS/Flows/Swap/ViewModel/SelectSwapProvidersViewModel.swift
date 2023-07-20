//
//  SwapProvidersViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import Foundation

class SelectSwapProvidersViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Providers"
	public let pageDescription = "Select the provider (default is the best)"
	public let confirmButtonTitle = "Got it"
	@Published
	public var providers: [SwapProviderViewModel]?

	// MARK: - Initializers

	init() {
		getProviders()
	}

	// MARK: - Private Methods

	private func getProviders() {
		// Temporary
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.providers = [
				SwapProviderViewModel(provider: .oneInch, swapAmount: "1,430 USDC"),
				SwapProviderViewModel(provider: .paraswap, swapAmount: "1,428 USDC"),
				SwapProviderViewModel(provider: .zeroX, swapAmount: "1,427 USDC"),
			]
		}
	}

	// MARK: - Public Methods

	public func getBestProvider(_ providers: [SwapProviderViewModel]) -> SwapProviderViewModel.SwapProvider? {
		// Temporary
		providers.first?.provider
	}
}
