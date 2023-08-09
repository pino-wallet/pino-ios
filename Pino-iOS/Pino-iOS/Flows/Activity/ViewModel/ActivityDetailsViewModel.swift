//
//  ActivityDetailsViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import Combine
import Foundation

class ActivityDetailsViewModel {
	// MARK: - Private Properties

	private let globalAssetsList = GlobalVariables.shared.manageAssetsList
	private let activityAPIClient = ActivityAPIClient()
	private let errorFetchingToastMessage = "Error fetching activity from server"
	private let activityHelper = ActivityHelper()
	private var requestTimer: Timer!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public var activityDetails: ActivityCellViewModel
	#warning("this is for test")
	public let unVerifiedAssetIconName = "unverified_asset"
	public let dismissNavigationIconName = "dissmiss"
	public let swapDownArrow = "swap_down_arrow"
	public let dateTitle = "Date"
	public let statusTitle = "Status"
	public let protocolTitle = "Protocol"
	public let providerTitle = "Provider"
	public let fromTitle = "From"
	public let toTitle = "To"
	public let typeTitle = "Type"
	public let feeTitle = "Fee"
	public let viewEthScanTitle = "View on etherscan"
	public let viewEthScanIconName = "primary_right_arrow"
	public let otherTokenTransactionMessage =
		"The history are only available for verified assets!"
	public let otherTokenTransactionIconName = "gray_error_alert"
	#warning("tooltips are for test")
	public let feeActionSheetText = "this is fee"
	public let statusActionSheetText = "this is status"
	public let typeActionSheetText = "this is type"

	@Published
	public var properties: ActivityDetailProperties!

	// MARK: - Initializers

	init(activityDetails: ActivityCellViewModel) {
		self.activityDetails = activityDetails
		self.properties = ActivityDetailProperties(
			activityDetails: activityDetails
		)
	}

	// MARK: - Public Methods

	public func getActivityDetailsFromVC() {
		if activityDetails.status == .pending {
			setupRequestTimer()
			requestTimer.fire()
		}
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	public func refreshData() {
		if activityDetails.status == .pending {
			requestTimer?.fire()
		} else {
			properties = properties
		}
	}

	// MARK: - Private Methods

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(getActivityDetails),
			userInfo: nil,
			repeats: true
		)
	}

	@objc
	private func getActivityDetails() {
		activityAPIClient.singleActivity(txHash: activityDetails.defaultActivityModel.txHash).sink { completed in
			switch completed {
			case .finished:
				print("Activity received successfully")
			case let .failure(error):
				switch error {
				case .notFound:
					self.properties = self.properties
				default:
					print("failed request")
				}
			}
		} receiveValue: { activityDetails in
			guard let iteratedActivity = self.activityHelper.iterateActivityModel(activity: activityDetails) else {
				return
			}
			let newActivityDetails = ActivityCellViewModel(activityModel: iteratedActivity)
			if newActivityDetails.status != .pending {
				self.destroyTimer()
			}
			self.properties = ActivityDetailProperties(
				activityDetails: newActivityDetails
			)
		}.store(in: &cancellables)
	}
}
