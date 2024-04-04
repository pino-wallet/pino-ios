//
//  CoinInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import Foundation
import Network
import PromiseKit

class CoinInfoViewModel {
	// MARK: - Public Properties

	public let homeVM: HomepageViewModel
	public let selectedAsset: AssetViewModel

	@Published
	public var coinPortfolio: CoinPortfolioViewModel!
	@Published
	public var coinHistoryActivitiesCellVMList: [ActivityCellViewModel]!

	public let requestFailedErrorToastMessage = "Couldn't refresh coin data"
	public let connectionErrorToastMessage = "No internet connection"
	public let infoActionSheetTitle = "Price impact"
	public let infoActionSheetDescription =
		"The difference between the market price and the estimated price based on your order size."
	public let websiteTitle = "Website"
	public let priceTitle = "Price"
	public let contractAddressTitle = "Contract address"
	public let protocolTitle = "Protocol"
	public let positionTitle = "Position type"
	public let assetTitle = "Underlying asset"
	public let tooltipIconName = "info"
	public let positionAssetTitle = "Position asset"
	public let priceSepratorText = "|"
	public let noUserAmountInDollarText = "--"
	public let unverifiedAssetIcon = "unverified_asset"
	public let noAssetPriceText = "-"

	public let unavailableRecentHistoryText = "History is only available for verified assets."
	public let unavailableRecentHistoryIconName = "alert"
	public let emptyActivityIconName = "no_activity"
	public let emptyActivityTitleText = "No activity"
	public var emptyActivityDescriptionText: String {
		"Your \(selectedAsset.symbol) activity appears here"
	}

	public var positionAssetInfoText: String? {
		guard let positionAssetType, let positionAssetProtocol, let positionUnderlyingAssetSymbol else { return nil }
		return "This asset represents your \(positionUnderlyingAssetSymbol) \(positionAssetType) position in the \(positionAssetProtocol) Protocol."
	}

	public var positionAssetProtocol: String? {
		currentPositionAsset?.assetProtocol.capitalized
	}

	public var positionAssetFormattedType: String? {
		positionAssetType?.capitalized
	}

	public var positionUnderlyingAssetSymbol: String? {
		let underlyingAsset = GlobalVariables.shared.manageAssetsList?
			.first(where: { $0.id.lowercased() == currentPositionAsset?.underlyingToken.lowercased() })
		return underlyingAsset?.symbol
	}

	// MARK: - Private Properties

	private let activityAPIClient = ActivityAPIClient()
	private let walletManager = PinoWalletManager()
	private let coreDataManager = CoreDataManager()
	private let activityHelper = ActivityHelper()
	private var isFirstTime = true
	private var requestTimer: Timer?
	private var prevAccountAddress: String!
	private var prevActivities: [ActivityModelProtocol] = []
	private var cancellables = Set<AnyCancellable>()
	private var pendingActivitiesCancellable = Set<AnyCancellable>()

	private var currentPositionAsset: PositionAssetModel? {
		homeVM.positionAssetDetailsList?.first(where: { selectedAsset.id.lowercased() == $0.positionID.lowercased() })
	}

	private var positionAssetType: String? {
		switch currentPositionAsset?.type {
		case .investment:
			return "investment"
		case .collateral:
			return "collateral"
		case nil:
			return nil
		}
	}

	// MARK: - Inintializers

	init(homeVM: HomepageViewModel, selectedAsset: AssetViewModel) {
		self.homeVM = homeVM
		self.selectedAsset = selectedAsset
		getCoinPortfolio()
		setPrevAccountAddress()
	}

	// MARK: - public Methods

	public func refreshCoinInfoData() -> Promise<Void> {
		requestTimer?.fire()
		return GlobalVariables.shared.fetchSharedInfo()
	}

	public func getUserActivitiesFromVC() {
		setupRequestTimer()
		setupBindings()
		requestTimer?.fire()
	}

	public func destroyTimer() {
		requestTimer?.invalidate()
		requestTimer = nil
	}

	public func cancellPendingActivitiesBinding() {
		pendingActivitiesCancellable.removeAll()
	}

	// MARK: - private Methods

	private func setupBindings() {
		PendingActivitiesManager.shared.$pendingActivitiesList.sink { pendingActivities in
			guard self.coinHistoryActivitiesCellVMList != nil else {
				return
			}
			let tokenPendingActivities = self.getFilteredTokenActivities(allActivities: pendingActivities)
			for pendingActivity in tokenPendingActivities {
				if self.prevActivities
					.indexOfActivityModel(activity: pendingActivity) == nil {
					self.prevActivities.append(pendingActivity)
					self.prevActivities = self.sortIteratedActivities(activities: self.prevActivities)
					self.coinHistoryActivitiesCellVMList = self.prevActivities
						.compactMap { ActivityCellViewModel(activityModel: $0) }
				}
			}
		}.store(in: &pendingActivitiesCancellable)
	}

	private func setPrevAccountAddress() {
		prevAccountAddress = walletManager.currentAccount.eip55Address
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(getHistoryList),
			userInfo: nil,
			repeats: true
		)
	}

	private func getCoinPortfolio() {
		coinPortfolio = CoinPortfolioViewModel(coinPortfolioModel: selectedAsset.assetModel)
	}

	private func getFilteredTokenActivities(allActivities: [ActivityModelProtocol]) -> [ActivityModelProtocol] {
		let selectedAssetLowerCasedID = selectedAsset.id.lowercased()
		return allActivities.filter { activity in
			switch ActivityType(rawValue: activity.type) {
			case .swap:
				let swapActivity = activity as! ActivitySwapModel
				if swapActivity.detail.fromToken.tokenID.lowercased() == selectedAssetLowerCasedID || swapActivity
					.detail
					.toToken.tokenID.lowercased() == selectedAssetLowerCasedID {
					return true
				}
				return false
			case .transfer, .transfer_from:
				let transferActivity = activity as! ActivityTransferModel
				if transferActivity.detail.tokenID.lowercased() == selectedAssetLowerCasedID {
					return true
				}
				return false
			case .approve:
				let approveActivity = activity as! ActivityApproveModel
				if approveActivity.detail.tokenID.lowercased() == selectedAssetLowerCasedID {
					return true
				}
				return false
			case .create_investment, .create_withdraw_investment, .increase_investment:
				let investActivity = activity as! ActivityInvestModel
				if investActivity.detail.tokens.containsTokenId(selectedAssetLowerCasedID) {
					return true
				}
				return false
			case .withdraw_investment, .decrease_investment:
				let withdrawActivity = activity as! ActivityWithdrawModel
				if withdrawActivity.detail.tokens.containsTokenId(selectedAssetLowerCasedID) {
					return true
				}
				return false
			case .create_collateral:
				let collateralActivity = activity as! ActivityCollateralModel
				if collateralActivity.detail.tokens.containsTokenId(selectedAssetLowerCasedID) {
					return true
				}
				return false
			case .swap_wrap, .swap_unwrap, .wrap_eth, .unwrap_eth:
				return false
			case .none:
				return false
			}
		}
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
		let coreDataVerifiedActivitiesList = coreDataManager
			.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
			.filter { ActivityStatus(rawValue: $0.status) != .pending }
		let coreDataIteratedVerifiedActivitiesList = coreDataVerifiedActivitiesList
			.compactMap { activityHelper.iterateCoreDataActivity(coreDataActivity: $0) }
		let tokenCoreDataIteratedVerifiedActivitiesList =
			getFilteredTokenActivities(allActivities: coreDataIteratedVerifiedActivitiesList)
		var updatedActivitiesList = activities
		for coreDataIteratedActivity in tokenCoreDataIteratedVerifiedActivitiesList {
			if let foundPendingActivityIndex = updatedActivitiesList
				.firstIndex(where: {
					$0.txHash.lowercased() == coreDataIteratedActivity.txHash.lowercased() && $0.failed == nil
				}) {
				updatedActivitiesList[foundPendingActivityIndex] = coreDataIteratedActivity
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

	@objc
	private func getHistoryList() {
		let userAddress = walletManager.currentAccount.eip55Address
		activityAPIClient.tokenActivities(userAddress: userAddress, tokenAddress: selectedAsset.id).sink { completed in
			switch completed {
			case .finished:
				print("Token activities received successfully")
			case let .failure(error):
				print("Error: getting token activities: \(error.description)")
				#warning("This function gets called multiple times so showing toast should be handled properly")
			}
		} receiveValue: { [weak self] fetchedActivities in
			guard let self else {
				return
			}
			let activitiesList = self.activityHelper
				.iterateActivitiesFromResponse(activities: fetchedActivities)
			var finalActivities: [ActivityModelProtocol] = []
			let allIteratedCoreDataActivities = coreDataManager
				.getUserAllActivities(userID: walletManager.currentAccount.eip55Address)
				.compactMap { self.activityHelper.iterateCoreDataActivity(coreDataActivity: $0) }
			let allTokenIteratedCoreDataActivities =
				getFilteredTokenActivities(allActivities: allIteratedCoreDataActivities)
			for iteratedCoreDataActivity in allTokenIteratedCoreDataActivities {
				if finalActivities
					.first(where: { $0.txHash.lowercased() == iteratedCoreDataActivity.txHash.lowercased() }) == nil {
					finalActivities
						.append(iteratedCoreDataActivity)
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
			coinHistoryActivitiesCellVMList = finalActivities.compactMap { ActivityCellViewModel(activityModel: $0) }
			self.prevActivities = finalActivities
		}.store(in: &cancellables)
	}
}
