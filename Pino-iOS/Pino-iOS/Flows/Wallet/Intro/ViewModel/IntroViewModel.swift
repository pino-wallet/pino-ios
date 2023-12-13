//
//  IntroViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//
// swiftlint: disable trailing_comma

struct IntroViewModel {
	// MARK: Public Properties

	public var contentList: [IntroModel]!
	public let createButtonTitle = "Create new wallet"
	public let importButtonTitle = "I already have a wallet"

	// MARK: Initializers

	init() {
		setupIntroContentList()
	}

	// MARK: - Private Methods

	private mutating func setupIntroContentList() {
		contentList = [
			IntroModel(
				image: "intro-exp",
				title: "A Gateway to DeFi Efficiency",
				description: "Interact with top DeFi protocols through app-native, intuitive interfaces."
			),
			IntroModel(
				image: "intro-exp",
				title: "Unified experience",
				description: "Interact with top DeFi protocols through app-native, intuitive interfaces."
			),
			IntroModel(
				image: "intro-metrics",
				title: "Insightful metrics",
				description: "Gain a realistic view of your profitability by tracking specialized metrics."
			),
			IntroModel(
				image: "intro-security",
				title: "Reinforced security",
				description: "Secure your interactions with Permit 2 and biometric authentication."
			),
		]
	}
}
