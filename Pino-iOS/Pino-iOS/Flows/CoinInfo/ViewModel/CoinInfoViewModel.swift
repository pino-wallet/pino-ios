//
//  CoinInfoViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import Foundation
import Network

class CoinInfoViewModel {
	// MARK: - Public Properties

	public let homeVM: HomepageViewModel
	public let selectedAsset: AssetViewModel

	@Published
	public var coinPortfolio: CoinPortfolioViewModel!
	@Published
	public var coinHistoryActivitiesList: [ActivityCellViewModel]!
	@Published
	public var coinHistoryNewActivitiesList: [ActivityCellViewModel] = []
	@Published
	public var shouldReplacedActivites: [ActivityCellViewModel] = []

	public let requestFailedErrorToastMessage = "Couldn't refresh coin data"
	public let connectionErrorToastMessage = "No internet connection"
	public let infoActionSheetTitle = "Price impact"
	public let infoActionSheetDescription =
		"The difference between the market price and the estimated price based on your order size."
	public let websiteTitle = "Website"
	public let priceTitle = "Price"
	public let contractAddressTitle = "Contract address"
	public let protocolTitle = "Protocol"
	public let positionTitle = "Position"
	public let assetTitle = "Asset"
	public let tooltipIconName = "info"
	public let positionAssetTitle = "Position asset"
	public let priceSepratorText = "|"
	public let noUserAmountInDollarText = "--"
	public let unverifiedAssetIcon = "unverified_asset"
	public let noAssetPriceText = "-"
	public let unavailableRecentHistoryText = "The history are only available for verified assets!"
	public let unavailableRecentHistoryIconName = "gray_error_alert"
	public let emptyActivityIconName = "no_activity"
	public let emptyActivityTitleText = "No activity"
    public var emptyActivityDescriptionText: String {
        "Your \(selectedAsset.symbol) activity appears here"
    }

	#warning("this text is for testing and should be removed")
	public let positionAssetInfoText = """
	This asset represents your DAI collateral
	 position in the Compound Protocol. Note that
	 transferring this asset to another address will
	 fully transfer your position to the new
	 address.
	"""

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

	// MARK: - Inintializers

	init(homeVM: HomepageViewModel, selectedAsset: AssetViewModel) {
		self.homeVM = homeVM
		self.selectedAsset = selectedAsset
		getCoinPortfolio()
		setPrevAccountAddress()
	}

	// MARK: - public Methods

	public func refreshCoinInfoData(completion: @escaping (APIError?) -> Void) {
		requestTimer?.fire()
		GlobalVariables.shared.fetchSharedInfo().catch { error in
			completion(APIError.unreachable)
		}
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
			guard self.coinHistoryActivitiesList != nil else {
				return
			}

			for pendingActivity in pendingActivities {
				let foundPendingActivityIndex = self.prevActivities
					.firstIndex(where: { $0.txHash == pendingActivity.prev_txHash })
				if foundPendingActivityIndex != nil {
					if self.prevActivities[foundPendingActivityIndex!].txHash != pendingActivity
						.txHash {
						self
							.shouldReplacedActivites.append(
								ActivityCellViewModel(activityModel: pendingActivity)
							)
						self.prevActivities[foundPendingActivityIndex!] = pendingActivity
					}
				}
			}
			self.shouldReplacedActivites = []

			let newPendingActivities = pendingActivities.filter { activity in
				!self.prevActivities.contains(where: { $0.txHash == activity.txHash })
			}
			let newCoinPendingActivities = self.getTokenPendingActivities(pendingActivities: newPendingActivities)
			self.coinHistoryNewActivitiesList = newCoinPendingActivities.compactMap {
				ActivityCellViewModel(activityModel: $0)
			}
			self.prevActivities.append(contentsOf: newCoinPendingActivities)

			let prevPendingActivities = self.prevActivities.filter { activity in
				activity.failed == nil
			}
			if prevPendingActivities.count > pendingActivities.count {
				self.requestTimer?.fire()
			}

		}.store(in: &pendingActivitiesCancellable)
	}

	private func setPrevAccountAddress() {
		prevAccountAddress = walletManager.currentAccount.eip55Address
	}

	private func setupRequestTimer() {
		requestTimer = Timer.scheduledTimer(
			timeInterval: 12,
			target: self,
			selector: #selector(getHistoryList),
			userInfo: nil,
			repeats: true
		)
	}

	private func getCoinPortfolio() {
		coinPortfolio = CoinPortfolioViewModel(coinPortfolioModel: selectedAsset.assetModel)
	}

	private func getTokenPendingActivities(pendingActivities: [ActivityModelProtocol]) -> [ActivityModelProtocol] {
		pendingActivities.filter { pendingActivity in
			switch ActivityType(rawValue: pendingActivity.type) {
			case .swap:
				let swapPendingActivity = pendingActivity as! ActivitySwapModel
				if swapPendingActivity.detail.fromToken.tokenID == selectedAsset.id || swapPendingActivity.detail
					.toToken.tokenID == selectedAsset.id {
					return true
				}
				return false
			case .transfer:
				let transferPendingActivity = pendingActivity as! ActivityTransferModel
				if transferPendingActivity.detail.tokenID == selectedAsset.id {
					return true
				}
				return false
			case .transfer_from:
				let transferPendingActivity = pendingActivity as! ActivityTransferModel
				if transferPendingActivity.detail.tokenID == selectedAsset.id {
					return true
				}
				return false
			default:
				return false
			}
		}
	}

	#warning("Needs to be refactored")
	@objc
	private func getHistoryList() {
		let userAddress = walletManager.currentAccount.eip55Address
		activityAPIClient.tokenActivities(userAddress: userAddress, tokenAddress: selectedAsset.id).sink { completed in
			switch completed {
			case .finished:
				print("Token activities received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { [weak self] activities in
			var iteratedActivities = self?.activityHelper
				.iterateActivitiesFromResponse(activities: activities) ?? []
			if (self?.isFirstTime) != nil {
				let coinPendingActivities = self?
					.getTokenPendingActivities(pendingActivities: PendingActivitiesManager.shared.pendingActivitiesList)
				iteratedActivities.append(contentsOf: coinPendingActivities ?? [])
				iteratedActivities = iteratedActivities
					.sorted(by: {
						self?.activityHelper.getActivityDate(activityBlockTime: $0.blockTime)
							.timeIntervalSince1970 ?? 1 > self?.activityHelper
							.getActivityDate(activityBlockTime: $1.blockTime)
							.timeIntervalSince1970 ?? 0
					})
				self?.isFirstTime = false
			}
			if self?.coinHistoryActivitiesList == nil || (self?.coinHistoryActivitiesList!.isEmpty)! {
				self?.coinHistoryActivitiesList = iteratedActivities.compactMap {
					ActivityCellViewModel(activityModel: $0)
				}
				self?.prevActivities = iteratedActivities
			} else {
				var newActivities: [ActivityModelProtocol] = []
				newActivities = iteratedActivities.filter { activity in
					!self!.prevActivities.contains { activity.txHash == $0.txHash }
				}

				self?.coinHistoryNewActivitiesList = newActivities.compactMap {
					ActivityCellViewModel(activityModel: $0)
				}
				self?.prevActivities.append(contentsOf: newActivities)

				for activity in iteratedActivities {
					let foundActivityIndex = self?.prevActivities
						.firstIndex(where: { $0.txHash == activity.txHash })
					guard foundActivityIndex != nil else {
						return
					}
					if self?.prevActivities[foundActivityIndex!].failed == nil && activity
						.failed != nil {
						guard let coreDataActivites = self?.coreDataManager.getAllActivities() else {
							return
						}
						if !coreDataActivites.isEmpty {
							PendingActivitiesManager.shared.startActivityPendingRequests()
						}
						self?.shouldReplacedActivites.append(ActivityCellViewModel(activityModel: activity))
						self?.prevActivities[foundActivityIndex!] = activity
					}
				}
				self?.shouldReplacedActivites = []
			}
		}.store(in: &cancellables)
	}
}
