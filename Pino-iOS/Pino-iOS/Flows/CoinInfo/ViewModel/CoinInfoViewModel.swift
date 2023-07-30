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
	public var coinHistoryList: [ActivityCellViewModel]!

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
	public let emptyActivityIconName = "empty_activity"
	public let emptyActivityTitleText = "There is no transaction history"

	#warning("this text is for testing and should be removed")
	public let positionAssetInfoText = """
	This asset represents your DAI collateral
	 position in the Compound Protocol. Note that
	 transferring this asset to another address will
	 fully transfer your position to the new
	 address.
	"""

	// MARK: - Private Properties

	private var activityAPIClient = ActivityAPIClient()
	private var walletManager = PinoWalletManager()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Inintializers

	init(homeVM: HomepageViewModel, selectedAsset: AssetViewModel) {
		self.homeVM = homeVM
		self.selectedAsset = selectedAsset
		getCoinPortfolio()
		getHistoryList()
	}

	// MARK: - public Methods

	public func refreshCoinInfoData(completion: @escaping (APIError?) -> Void) {
		getHistoryList()
		GlobalVariables.shared.fetchSharedInfo().catch { error in
			completion(APIError.unreachable)
		}
	}

	// MARK: - private Methods

	private func getCoinPortfolio() {
		coinPortfolio = CoinPortfolioViewModel(coinPortfolioModel: selectedAsset.assetModel)
	}

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
            let filteredActivities = activities.filter({ActivityType(rawValue: $0.type) != nil})
			self?.coinHistoryList = filteredActivities.compactMap {
				ActivityCellViewModel(activityModel: $0)
			}
		}.store(in: &cancellables)
	}
}
