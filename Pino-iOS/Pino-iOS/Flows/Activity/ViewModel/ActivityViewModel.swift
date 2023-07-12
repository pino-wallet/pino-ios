//
//  ActivityViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/8/23.
//

import Combine
import Foundation

class ActivityViewModel {
	// MARK: - Public Properties

	public let pageTitle = "Recent activity"
	public let noActivityMessage = "There is no activity"
	public let noActivityIconName = "empty_activity"

	@Published
	public var userActivities: [ActivityCellViewModel]? = nil

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let walletManager = PinoWalletManager()
	private var cancellables = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var userAddress: String!

	// MARK: - Initializers

	init() {
		self.userAddress = walletManager.currentAccount.eip55Address

		setupRequestTimer()
	}

	// MARK: - Public Properties

	public func refreshUserActivities() {
		setupRequestTimer()
		if userActivities == nil || userAddress != walletManager.currentAccount.eip55Address {
			userAddress = walletManager.currentAccount.eip55Address
			userActivities = nil
			requestTimer?.fire()
		}
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	// MARK: - Private Methods

	private func setupRequestTimer() {
		destroyTimer()
		requestTimer = Timer.scheduledTimer(
			timeInterval: 7,
			target: self,
			selector: #selector(getUserActivities),
			userInfo: nil,
			repeats: true
		)
	}

	@objc
	private func getUserActivities() {
		let userAddress = walletManager.currentAccount.eip55Address
		activityAPIClient.allActivities(userAddress: userAddress).sink { completed in
			switch completed {
			case .finished:
				print("User activities received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] activities in
			print(activities)
			self?.userActivities = activities.compactMap {
				ActivityCellViewModel(activityModel: $0, currentAddress: userAddress)
			}
		}.store(in: &cancellables)
	}
}
