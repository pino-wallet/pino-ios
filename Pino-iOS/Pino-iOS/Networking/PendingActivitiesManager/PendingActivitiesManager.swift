//
//  PendingActivitiesManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//

import Combine
import Foundation

class PendingActivitiesManager {
	// MARK: - Public Shared Accessor

	public static let shared = PendingActivitiesManager()

	// MARK: - Public Properties

	@Published
	public var pendingActivitiesList: [ActivityModelProtocol] = []

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let activityHelper = ActivityHelper()
	private let coreDataManager = CoreDataManager()
	private let requestsDispatchGroup = DispatchGroup()
	private let walletManager = PinoWalletManager()
	private var requestsTimer: Cancellable?
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Methods

	public func startActivityPendingRequests() {
		getPendingActivitiesFromCoreData()
		stopActivityPendingRequests()
		requestsTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect().prepend(Date()).sink { _ in
			self.getActivityPendings()
		}
	}

	public func stopActivityPendingRequests() {
		requestsTimer?.cancel()
		requestsTimer = nil
	}

	public func removePendingActivity(txHash: String) {
		pendingActivitiesList.removeAll(where: { $0.txHash.lowercased() == txHash.lowercased() })
        coreDataManager.deleteActivityByID(txHash)
		if pendingActivitiesList.isEmpty {
			stopActivityPendingRequests()
		}
	}

	// MARK: - Private Methods

	private func getPendingActivitiesFromCoreData() {
		pendingActivitiesList = []
		let allUserPendingActivities = coreDataManager
			.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
			.filter { ActivityStatus(rawValue: $0.status) == ActivityStatus.pending }
		for activity in allUserPendingActivities {
            pendingActivitiesList.append(activityHelper.iterateCoreDataActivity(coreDataActivity: activity))
		}
	}

	private func getActivityPendings() {
		for pendingActivity in pendingActivitiesList {
			requestsDispatchGroup.enter()
			activityAPIClient.singleActivity(txHash: pendingActivity.txHash).sink { completed in
				switch completed {
				case .finished:
					print("Activity received successfully")
				case let .failure(error):
					print(error)
				}
			} receiveValue: { activity in
				let iteratedActivity = self.activityHelper.iterateActivityModel(activity: activity)
				if ActivityType(rawValue: iteratedActivity.type) != nil {
					self.pendingActivitiesList.removeAll(where: { $0.txHash == iteratedActivity.txHash })
					self.coreDataManager.deleteActivityByID(iteratedActivity.txHash)
					if self.pendingActivitiesList.isEmpty {
						self.stopActivityPendingRequests()
					}
				} else {
					self.pendingActivitiesList.removeAll(where: { $0.txHash == iteratedActivity.txHash })
					self.coreDataManager
						.changePendingActivityToDone(activityModel: iteratedActivity as! ActivityBaseModel)
					if self.pendingActivitiesList.isEmpty {
						self.stopActivityPendingRequests()
					}
				}

				self.requestsDispatchGroup.leave()
			}.store(in: &cancellables)
		}
	}
}
