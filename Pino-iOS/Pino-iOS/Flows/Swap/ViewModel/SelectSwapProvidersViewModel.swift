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
	public var bestProvider: SwapProviderViewModel?
	public var selectedProvider: SwapProviderViewModel?
}
