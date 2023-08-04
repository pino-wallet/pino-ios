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
	private let activityHelper = ActivityHelper()
	private var cancellables = Set<AnyCancellable>()
	private var requestTimer: Timer?
	private var prevActivities: [ActivityModelProtocol] = []

	// MARK: - Public Properties
let test = CoreDataManager()
	public func getUserActivitiesFromVC() {
		setupRequestTimer()
		requestTimer?.fire()
        
        test.addNewSwapActivity(activityModel: ActivitySwapModel(txHash: "eh", type: "ho", detail: SwapActivityDetails(fromToken: ActivityTokenModel(amount: "24142", tokenID: "4151"), toToken: ActivityTokenModel(amount: "41515", tokenID: "135151"), userID: "mamad", activityProtocol: "eh"), fromAddress: "eheee", toAddress: "omm", failed: true, blockNumber: 1313, blockTime: "14", gasUsed: "15151", gasPrice: "41414214"))
//        print("heh", test.addNewSwapActivity(activityModel: ActivitySwapModel(txHash: "eh", type: "ho", detail: SwapActivityDetails(fromToken: nil, toToken: nil, userID: "mamad", activityProtocol: "eh"), fromAddress: "eheee", toAddress: "omm", failed: true, blockNumber: 1313, blockTime: "14", gasUsed: "15151", gasPrice: "41414214")).details?.userID)
        let eh = test.getAllActivities()[0] as! CoreDataSwapActivity
//        test.deleteActivityByID("eh")
        print("heh", eh.details?.userID, test.getAllActivities().count)
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
			let iteratedActivities = self?.activityHelper.iterateActivitiesFromResponse(activities: activities) ?? []
			if self?.userActivities == nil || (self?.userActivities!.isEmpty)! {
				self?.userActivities = iteratedActivities.compactMap {
					ActivityCellViewModel(activityModel: $0)
				}
				self?.prevActivities = iteratedActivities
			} else {
				var newActivities: [ActivityModelProtocol] = []
				newActivities = iteratedActivities.filter { activity in
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
