//
//  IntroViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//
// swiftlint: disable trailing_comma

import Combine

class IntroViewModel {
	// MARK: - Public Properties

	public var contentList: [IntroModel]!
	public let createButtonTitle = "Create new wallet"
	public let importButtonTitle = "I already have a wallet"
	public var userCanTestBeta: Bool?

	// MARK: - Private Properties

	private let accountingClient = AccountingAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init() {
		setupIntroContentList()
	}

	// MARK: - Private Methods

	private func setupIntroContentList() {
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

	// MARK: - Public Methods

	public func checkBetaAvailibity(completion: ((Bool) -> Void)? = nil) {
		accountingClient.validateDeviceForBeta().sink { completed in
			switch completed {
			case .finished:
				print("Info received successfully")
			case let .failure(error):
				print(error)
				self.userCanTestBeta = false
				completion?(false)
			}
		} receiveValue: { [weak self] response in
			guard let self = self else { return }
			if response.valid {
				self.userCanTestBeta = true
				completion?(true)
			} else {
				self.userCanTestBeta = false
				completion?(false)
			}
		}.store(in: &cancellables)
	}
}
