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
	public var userActivities: [ActivityCellViewModel]? = nil

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
		if prevAccountAddress != walletManager.currentAccount.eip55Address {
			refreshPrevData()
			setPrevAccountAddress()
		}
		setupRequestTimer()
		setupBindings()
        requestTimer?.fire()
	}

	public func refreshUserActvities() {
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
			timeInterval: 12,
			target: self,
			selector: #selector(getUserActivities),
			userInfo: nil,
			repeats: true
		)
	}

	private func setupBindings() {
        GlobalVariables.shared.$manageAssetsList.compactMap { $0 }.sink { _ in
            if self.userActivities == nil {
                self.requestTimer?.fire()
            }
        }.store(in: &cancellables)
		PendingActivitiesManager.shared.$pendingActivitiesList.sink { pendingActivities in
			guard self.userActivities != nil else {
				return
			}
            var finalActivities = self.prevActivities
            for pendingActivity in pendingActivities {
                if finalActivities.first(where: { $0.txHash.lowercased() == pendingActivity.txHash.lowercased() }) == nil {
                    finalActivities.append(pendingActivity)
                    finalActivities = self.sortIteratedActivities(activities: finalActivities)
                    self.userActivities = finalActivities.compactMap { ActivityCellViewModel(activityModel: $0) }
                    self.prevActivities = finalActivities
                    self.shouldUpdateActivities = false
                }
            }
        }.store(in: &pendingActivitiesCancellable)
	}

	private func refreshPrevData() {
		userActivities = nil
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
                return Array(sortedActivities.prefix(upTo: 20))
                  } else {
                return sortedActivities
            }
    }
    
    private func getUpdatedPendingActivitiesFromCoreData(activities: [ActivityModelProtocol]) -> [ActivityModelProtocol] {
        let coreDataIteratedActivities = coreDataManager.getUserAllActivities(userID: walletManager.currentAccount.eip55Address).filter { ActivityStatus(rawValue: $0.status) != .pending }
        var updatedActivitiesList = activities
        for coreDataActivity in coreDataIteratedActivities {
            if let foundPendingActivityIndex = updatedActivitiesList.firstIndex(where: { $0.txHash.lowercased() == coreDataActivity.txHash.lowercased() }) {
                updatedActivitiesList[foundPendingActivityIndex] = activityHelper.iterateCoreDataActivity(coreDataActivity: coreDataActivity)
                shouldUpdateActivities = true
            }
        }
        return updatedActivitiesList
    }
    
    private func getUpdatedPendingActivitiesFromResponse(responseActivities: [ActivityModelProtocol], activities: [ActivityModelProtocol]) -> [ActivityModelProtocol] {
        var updatedActivitiesList = activities
        for responseActivity in responseActivities {
            if let foundPendingActivityIndex = updatedActivitiesList.firstIndex(where: { $0.txHash.lowercased() == responseActivity.txHash.lowercased() }) {
                updatedActivitiesList[foundPendingActivityIndex] = responseActivity
                shouldUpdateActivities = true
            }
        }
        return updatedActivitiesList
    }
    
    private func checkForPendingActivityListChanges(responseActivities: [ActivityModelProtocol]) {
        for responseActivity in responseActivities {
            if let foundPendingActivityInResponse = PendingActivitiesManager.shared.pendingActivitiesList.first(where: { $0.txHash.lowercased() == responseActivity.txHash.lowercased() }) {
                PendingActivitiesManager.shared.removePendingActivity(txHash: foundPendingActivityInResponse.txHash)
            }
        }
    }
    
    private func checkForNewActivity(responseActivities: [ActivityModelProtocol]) {
        guard userActivities != nil else {
            shouldUpdateActivities = true
            return
        }
        for newActivity in responseActivities {
            if prevActivities.first(where: { $0.txHash.lowercased() == newActivity.txHash.lowercased() }) == nil {
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
            } receiveValue: { [weak self] activities in
                guard let self, GlobalVariables.shared.manageAssetsList != nil else {
                    return
                }
                let iteratedActivities = self.activityHelper
                    .iterateActivitiesFromResponse(activities: activities)
                var finalActivities = iteratedActivities
                for pendingCoreDataActivity in PendingActivitiesManager.shared.pendingActivitiesList {
                    if finalActivities.first(where: { $0.txHash.lowercased() == pendingCoreDataActivity.txHash.lowercased() }) == nil {
                        finalActivities.append(pendingCoreDataActivity)
                    }
                }
                let doneCoreDataActivities = coreDataManager.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
                for doneCoreDataActivity in doneCoreDataActivities {
                    if finalActivities.first(where: { $0.txHash.lowercased() == doneCoreDataActivity.txHash.lowercased() }) == nil {
                        finalActivities.append(activityHelper.iterateCoreDataActivity(coreDataActivity: doneCoreDataActivity))
                    }
                }
                if self.prevActivities.isEmpty {
                    finalActivities = sortIteratedActivities(activities: finalActivities)
                } else {
                    finalActivities = getUpdatedPendingActivitiesFromResponse(responseActivities: iteratedActivities, activities: finalActivities)
                    finalActivities = getUpdatedPendingActivitiesFromCoreData(activities: finalActivities)
                    finalActivities = sortIteratedActivities(activities: finalActivities)
                }
                checkForPendingActivityListChanges(responseActivities: iteratedActivities)
                checkForNewActivity(responseActivities: iteratedActivities)
                if shouldUpdateActivities {
                    userActivities = finalActivities.compactMap { ActivityCellViewModel(activityModel: $0) }
                    self.prevActivities = finalActivities
                    self.shouldUpdateActivities = false
                }
            }.store(in: &cancellables)
    }
}
