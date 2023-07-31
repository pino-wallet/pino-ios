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
	public let errorFetchingToastMessage = "Error fetching activities from server"

	@Published
	public var userActivities: [ActivityCellViewModel]? = nil
	@Published
	public var newUserActivities: [ActivityCellViewModel] = []

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let walletManager = PinoWalletManager()
	private var cancellables = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var prevActivities: ActivitiesModel = []

	// MARK: - Public Properties

	public func getUserActivitiesFromVC() {
		setupRequestTimer()
		requestTimer?.fire()
	}

	public func destroyPrevData() {
		userActivities = nil
		prevActivities = []
		newUserActivities = []
	}

	public func refreshUserActvities() {
		requestTimer?.fire()
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	// MARK: - Private Methods

	private func setupRequestTimer() {
		destroyTimer()
		requestTimer = Timer.scheduledTimer(
			timeInterval: 12,
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
				Toast.default(
					title: self.errorFetchingToastMessage,
					subtitle: GlobalToastTitles.tryAgainToastTitle.message,
					style: .error
				)
				.show(haptic: .warning)
			}
		} receiveValue: { [weak self] activities in
			let filteredActivities = activities.filter { ActivityType(rawValue: $0.type) != nil }
			if self?.userActivities == nil || (self?.userActivities!.isEmpty)! {
				self?.userActivities = filteredActivities.compactMap {
					ActivityCellViewModel(activityModel: $0)
				}
				self?.prevActivities = filteredActivities
			} else {
				var newActivities: ActivitiesModel = []
				newActivities = filteredActivities.filter { activity in
					!self!.prevActivities.contains { activity.txHash == $0.txHash }
				}
				self?.newUserActivities = newActivities.compactMap {
					ActivityCellViewModel(activityModel: $0)
				}
				self?.prevActivities.append(contentsOf: newActivities)
			}
		}.store(in: &cancellables)
	}
}
