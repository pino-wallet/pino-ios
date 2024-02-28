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
	public let noActivityTitleText = "No activity"
	public let noActivityDescriptionText = "Your activity appears here"
	public let noActivityIconName = "no_activity"
	public let errorFetchingToastMessage = "Error fetching activities from server"

	@Published
	public var userActivityCellVMList: [ActivityCellViewModel]? = nil

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let walletManager = PinoWalletManager()
	private let activityHelper = ActivityHelper()
	private var cancellables = Set<AnyCancellable>()
	private var pendingActivitiesCancellable = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var prevActivities: [ActivityModelProtocol] = []
	private var prevAccountAddress: String!
	private var coreDataManager = CoreDataManager()
	private var shouldUpdateActivities = true

	// MARK: - Initializers

	init() {
		setPrevAccountAddress()
	}

	// MARK: - Public Properties

	public func getUserActivitiesFromVC() {
        if prevAccountAddress != walletManager.currentAccount.eip55Address || prevActivities.first(where: { $0.failed == nil }) != nil {
			refreshPrevData()
			setPrevAccountAddress()
		}
		setupRequestTimer()
		setupBindings()
		requestTimer?.fire()
	}

	public func refreshUserActvities() {
		shouldUpdateActivities = true
		requestTimer?.fire()
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	public func cancellPendingActivitiesBinding() {
		pendingActivitiesCancellable.removeAll()
	}

	// MARK: - Private Methods

	private func setupRequestTimer() {
		destroyTimer()
		requestTimer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(getUserActivities),
			userInfo: nil,
			repeats: true
		)
	}

	private func setupBindings() {
		GlobalVariables.shared.$manageAssetsList.compactMap { $0 }.sink { _ in
			if self.userActivityCellVMList == nil {
				self.requestTimer?.fire()
			}
		}.store(in: &cancellables)
		PendingActivitiesManager.shared.$pendingActivitiesList.sink { pendingActivities in
			guard self.userActivityCellVMList != nil else {
				return
			}
			for pendingActivity in pendingActivities {
				if self.prevActivities
					.indexOfActivityModel(activity: pendingActivity) == nil {
					self.prevActivities.append(pendingActivity)
					self.prevActivities = self.sortIteratedActivities(activities: self.prevActivities)
					self.userActivityCellVMList = self.prevActivities.compactMap { ActivityCellViewModel(activityModel: $0) }
					self.shouldUpdateActivities = false
				}
			}
		}.store(in: &pendingActivitiesCancellable)
	}

	private func refreshPrevData() {
		userActivityCellVMList = nil
		prevActivities = []
		shouldUpdateActivities = true
	}

	private func setPrevAccountAddress() {
		prevAccountAddress = walletManager.currentAccount.eip55Address
	}

	private func sortIteratedActivities(activities: [ActivityModelProtocol]) -> [ActivityModelProtocol] {
		let activityLimitCount = 20
		let sortedActivities = activities.sorted(by: {
			activityHelper.getActivityDate(activityBlockTime: $0.blockTime)
				.timeIntervalSince1970 > activityHelper.getActivityDate(activityBlockTime: $1.blockTime)
				.timeIntervalSince1970
		})
		if sortedActivities.count > activityLimitCount {
			return Array(sortedActivities.prefix(upTo: activityLimitCount))
		} else {
			return sortedActivities
		}
	}

	private func getUpdatedPendingActivitiesFromCoreData(activities: [ActivityModelProtocol])
		-> [ActivityModelProtocol] {
		let coredataVerifiedActivitiesList = coreDataManager
			.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
			.filter { ActivityStatus(rawValue: $0.status) != .pending }
		var updatedActivitiesList = activities
		for coreDataActivity in coredataVerifiedActivitiesList {
			if let foundPendingActivityIndex = updatedActivitiesList
				.firstIndex(where: { $0.txHash.lowercased() == coreDataActivity.txHash.lowercased() && $0.failed == nil
				}) {
				updatedActivitiesList[foundPendingActivityIndex] = activityHelper
					.iterateCoreDataActivity(coreDataActivity: coreDataActivity)
				shouldUpdateActivities = true
			}
		}
		return updatedActivitiesList
	}

	private func getUpdatedPendingActivitiesFromResponse(
		responseActivities: [ActivityModelProtocol],
		activities: [ActivityModelProtocol]
	) -> [ActivityModelProtocol] {
		var updatedActivitiesList = activities
		for responseActivity in responseActivities {
			if let foundPendingActivityIndex = updatedActivitiesList
				.firstIndex(where: { $0.txHash.lowercased() == responseActivity.txHash.lowercased() && $0.failed == nil
				}) {
				updatedActivitiesList[foundPendingActivityIndex] = responseActivity
				shouldUpdateActivities = true
			}
		}
		return updatedActivitiesList
	}

	private func checkForPendingActivityListChanges(responseActivities: [ActivityModelProtocol]) {
		for responseActivity in responseActivities {
			if let foundPendingActivityInResponse = PendingActivitiesManager.shared.pendingActivitiesList
				.first(where: { $0.txHash.lowercased() == responseActivity.txHash.lowercased() }) {
				PendingActivitiesManager.shared.removePendingActivity(txHash: foundPendingActivityInResponse.txHash)
			}
		}
	}

	private func checkForNewActivity(responseActivities: [ActivityModelProtocol]) {
		guard userActivityCellVMList != nil else {
			shouldUpdateActivities = true
			return
		}
		for newActivity in responseActivities {
			if prevActivities.indexOfActivityModel(activity: newActivity) == nil {
				shouldUpdateActivities = true
			}
			if prevActivities
				.first(where: { $0.txHash.lowercased() == newActivity.txHash.lowercased() && $0.failed == nil }) != nil {
				shouldUpdateActivities = true
			}
		}
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
		} receiveValue: { [weak self] fetchedActivities in
			guard let self, GlobalVariables.shared.manageAssetsList != nil else {
				return
			}
			let activitiesList = self.activityHelper
				.iterateActivitiesFromResponse(activities: fetchedActivities)
			var finalActivities: [ActivityModelProtocol] = []
			let allCoreDataActivities = coreDataManager
				.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
			for coreDataActivity in allCoreDataActivities {
				if finalActivities
					.first(where: { $0.txHash.lowercased() == coreDataActivity.txHash.lowercased() }) == nil {
					finalActivities
						.append(activityHelper.iterateCoreDataActivity(coreDataActivity: coreDataActivity))
				}
			}

			if !self.prevActivities.isEmpty {
				finalActivities = getUpdatedPendingActivitiesFromResponse(
					responseActivities: activitiesList,
					activities: finalActivities
				)
				finalActivities = getUpdatedPendingActivitiesFromCoreData(activities: finalActivities)
				finalActivities = sortIteratedActivities(activities: finalActivities)
			}

			for activity in activitiesList {
				if finalActivities.indexOfActivityModel(activity: activity) == nil {
					finalActivities.append(activity)
				}
			}

			finalActivities = sortIteratedActivities(activities: finalActivities)

			checkForPendingActivityListChanges(responseActivities: activitiesList)
			checkForNewActivity(responseActivities: activitiesList)
			if shouldUpdateActivities {
				userActivityCellVMList = finalActivities.compactMap { ActivityCellViewModel(activityModel: $0) }
				self.prevActivities = finalActivities
				self.shouldUpdateActivities = false
			}
		}.store(in: &cancellables)
	}
}


