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

	private var requestsTimer: Cancellable?
	private var activityAPIClient = ActivityAPIClient()
	private var activityHelper = ActivityHelper()
	private var cancellables = Set<AnyCancellable>()
	private var coreDataManager = CoreDataManager()
	private var requestsDispatchGroup = DispatchGroup()

	// MARK: - Public Methods

	public func startActivityPendingRequests() {
		getPendingActivitiesFromCoreData()
		stopActivityPendingRequests()
		getActivityPendings()
		requestsTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect().sink { _ in
			self.getActivityPendings()
		}
	}

	public func stopActivityPendingRequests() {
		requestsTimer?.cancel()
		requestsTimer = nil
	}

	// MARK: - Private Methods

	private func getPendingActivitiesFromCoreData() {
		for activity in coreDataManager.getAllActivities() {
			switch ActivityType(rawValue: activity.type) {
			case .swap:
				pendingActivitiesList.append(ActivitySwapModel(
					txHash: activity.txHash,
					type: activity.type,
					fromAddress: activity.fromAddress,
					toAddress: activity.toAddress,
					failed: nil,
					blockNumber: nil,
					blockTime: activity.blockTime,
					gasUsed: activity.gasUsed,
					gasPrice: activity.gasPrice
				))
			case .transfer:
				pendingActivitiesList.append(ActivityTransferModel(
					txHash: activity.txHash,
					type: activity.type,
					fromAddress: activity.fromAddress,
					toAddress: activity.toAddress,
					failed: nil,
					blockNumber: nil,
					blockTime: activity.blockTime,
					gasUsed: activity.gasUsed,
					gasPrice: activity.gasPrice
				))
			case .transfer_from:
				pendingActivitiesList.append(ActivityTransferModel(
					txHash: activity.txHash,
					type: activity.type,
					fromAddress: activity.fromAddress,
					toAddress: activity.toAddress,
					failed: nil,
					blockNumber: nil,
					blockTime: activity.blockTime,
					gasUsed: activity.gasUsed,
					gasPrice: activity.gasPrice
				))
			default:
				print("unknown activity type")
			}
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
				if activity != nil {
					let iteratedActivity = self.activityHelper.iterateActivityModel(activity: activity!)
					self.pendingActivitiesList.removeAll(where: { $0.txHash == iteratedActivity!.txHash })
					if self.pendingActivitiesList.isEmpty {
						self.stopActivityPendingRequests()
					}
				}
				self.requestsDispatchGroup.leave()
			}.store(in: &cancellables)
		}
	}
}
