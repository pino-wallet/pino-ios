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

	// MARK: - Private Methods

	private func getPendingActivitiesFromCoreData() {
		pendingActivitiesList = []
		let allUserPendingActivities = coreDataManager
			.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
			.filter { ActivityStatus(rawValue: $0.status) == ActivityStatus.pending }
		for activity in allUserPendingActivities {
			switch ActivityType(rawValue: activity.type) {
			case .swap:
				let cdSwapActivity = activity as! CDSwapActivity
				pendingActivitiesList.append(ActivitySwapModel(cdSwapActivityModel: cdSwapActivity))
			case .transfer:
				let cdTransferActivity = activity as! CDTransferActivity
				pendingActivitiesList.append(ActivityTransferModel(cdTransferActivityModel: cdTransferActivity))
			case .transfer_from:
				let cdTransferActivity = activity as! CDTransferActivity
				pendingActivitiesList.append(ActivityTransferModel(cdTransferActivityModel: cdTransferActivity))
			case .approve:
				let cdApproveActivity = activity as! CDApproveActivity
				pendingActivitiesList.append(ActivityApproveModel(cdApproveActivityModel: cdApproveActivity))
			case .create_investment, .increase_investment:
				let cdInvestActivity = activity as! CDInvestActivity
				pendingActivitiesList.append(ActivityInvestModel(cdInvestActivityModel: cdInvestActivity))
			case .decrease_investment, .withdraw_investment:
				let cdWithdrawActivity = activity as! CDWithdrawActivity
				pendingActivitiesList.append(ActivityWithdrawModel(cdWithDrawActivityModel: cdWithdrawActivity))
			case .borrow:
				let cdBorrowActivity = activity as! CDBorrowActivity
				pendingActivitiesList.append(ActivityBorrowModel(cdBorrowActivityModel: cdBorrowActivity))
			case .repay:
				let cdRepayActivity = activity as! CDRepayActivity
				pendingActivitiesList.append(ActivityRepayModel(cdRepayActivityModel: cdRepayActivity))
			case .increase_collateral, .decrease_collateral, .create_collateral, .remove_collateral,
			     .enable_collateral,
			     .disable_collateral:
				let cdCollateralActivity = activity as! CDCollateralActivity
				pendingActivitiesList.append(ActivityCollateralModel(cdCollateralActivityModel: cdCollateralActivity))
			case .wrap_eth, .swap_wrap:
				let cdWrapETHActivity = activity as! CDWrapETHActivity
				pendingActivitiesList.append(ActivityWrapETHModel(cdApproveActivityModel: cdWrapETHActivity))
			case .unwrap_eth, .swap_unwrap:
				let cdUnwrapETHActivity = activity as! CDUnwrapETHActivity
				pendingActivitiesList.append(ActivityUnwrapETHModel(cdApproveActivityModel: cdUnwrapETHActivity))
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
