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
		getActivityPendings()
		requestsTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect().sink { _ in
			self.getActivityPendings()
		}
	}

	public func stopActivityPendingRequests() {
		requestsTimer?.cancel()
		requestsTimer = nil
	}

	// MARK: - Private Methods

	private func getPendingActivitiesFromCoreData() {
		pendingActivitiesList = []
		for activity in coreDataManager.getAllActivities() {
			if activity.accountAddress == walletManager.currentAccount.eip55Address {
				switch ActivityType(rawValue: activity.type) {
				case .swap:
					let cdSwapActivity = activity as! CDSwapActivity
					pendingActivitiesList.append(ActivitySwapModel(
						txHash: cdSwapActivity.txHash,
						type: cdSwapActivity.type,
						detail: SwapActivityDetails(
							fromToken: ActivityTokenModel(
								amount: cdSwapActivity.details.from_token.amount,
								tokenID: cdSwapActivity.details.from_token.tokenId
							),
							toToken: ActivityTokenModel(
								amount: cdSwapActivity.details.to_token.amount,
								tokenID: cdSwapActivity.details.to_token.tokenId
							),
							activityProtocol: cdSwapActivity.details.activityProtool
						),
						fromAddress: cdSwapActivity.fromAddress,
						toAddress: cdSwapActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdSwapActivity.blockTime,
						gasUsed: cdSwapActivity.gasUsed,
						gasPrice: cdSwapActivity.gasPrice,
						prev_txHash: cdSwapActivity.prevTxHash
					))
				case .transfer:
					let cdTransferActivity = activity as! CDTransferActivity
					pendingActivitiesList.append(ActivityTransferModel(
						txHash: cdTransferActivity.txHash,
						type: cdTransferActivity.type,
						detail: TransferActivityDetail(
							amount: cdTransferActivity.details.amount,
							tokenID: cdTransferActivity.details.tokenID,
							from: cdTransferActivity.details.from,
							to: cdTransferActivity.details.to
						),
						fromAddress: cdTransferActivity.fromAddress,
						toAddress: cdTransferActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdTransferActivity.blockTime,
						gasUsed: cdTransferActivity.gasUsed,
						gasPrice: cdTransferActivity.gasPrice,
						prev_txHash: cdTransferActivity.prevTxHash
					))
				case .transfer_from:
					let cdTransferActivity = activity as! CDTransferActivity
					pendingActivitiesList.append(ActivityTransferModel(
						txHash: cdTransferActivity.txHash,
						type: cdTransferActivity.type,
						detail: TransferActivityDetail(
							amount: cdTransferActivity.details.amount,
							tokenID: cdTransferActivity.details.tokenID,
							from: cdTransferActivity.details.from,
							to: cdTransferActivity.details.to
						),
						fromAddress: cdTransferActivity.fromAddress,
						toAddress: cdTransferActivity.toAddress,
						failed: nil,
						blockNumber: nil,
						blockTime: cdTransferActivity.blockTime,
						gasUsed: cdTransferActivity.gasUsed,
						gasPrice: cdTransferActivity.gasPrice,
						prev_txHash: cdTransferActivity.prevTxHash
					))
				default:
					print("unknown activity type")
				}
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
				let iteratedActivity = self.activityHelper.iterateActivityModel(activity: activity)
				if iteratedActivity != nil {
					self.pendingActivitiesList.removeAll(where: { $0.txHash == iteratedActivity!.txHash })
					self.coreDataManager.deleteActivityByID(iteratedActivity!.txHash)
					if self.pendingActivitiesList.isEmpty {
						self.stopActivityPendingRequests()
					}
				}
				self.requestsDispatchGroup.leave()
			}.store(in: &cancellables)
		}
	}
}
