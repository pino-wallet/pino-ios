//
//  IntroViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
//
// swiftlint: disable trailing_comma

import Combine
import UIKit

class IntroViewModel {
	// MARK: - Public Properties

	public var contentList: [IntroModel]!
	public let createButtonTitle = "Create new wallet"
	public let importButtonTitle = "I already have a wallet"

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
				description: "Interact with top DeFi protocols through simple, app-native interfaces."
			),
			IntroModel(
				image: "intro-exp",
				title: "Unified experience",
				description: "Interact with top DeFi protocols through simple, app-native interfaces."
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
		if UIDevice.current.isSimulator {
			completion?(true)
			return
		}
		accountingClient.validateDeviceForBeta().sink { completed in
			switch completed {
			case .finished:
				print("Info received successfully")
			case let .failure(error):
				print(error)
				completion?(false)
			}
		} receiveValue: { [weak self] response in
			guard self != nil else { return }
			if response.valid {
				completion?(true)
			} else {
				completion?(false)
			}
		}.store(in: &cancellables)
	}
}
