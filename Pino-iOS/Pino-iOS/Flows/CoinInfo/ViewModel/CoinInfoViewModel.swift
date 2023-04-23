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

	@Published
	public var coinPortfolio: CoinPortfolioViewModel!
	@Published
	public var coinHistoryList: [CoinHistoryViewModel]!

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
	public let recentHistoryTitle = "Recent history"
	public let tooltipIconName = "info"
	public let positionAssetTitle = "Position asset"
	public let priceSepratorText = "|"
	public let noUserAmountInDollarText = "--"
	public let unverifiedAssetIcon = "unverified_asset"
	public let noAssetPriceText = "-"
	public let unavailableRecentHistoryText = "The history are only available for verified assets!"
	public let unavailableRecentHistoryIconName = "gray_error_alert"

	#warning("this text is for testing and should be removed")
	public let positionAssetInfoText = """
	This asset represents your DAI collateral
	 position in the Compound Protocol. Note that
	 transferring this asset to another address will
	 fully transfer your position to the new
	 address.
	"""

	// MARK: - Private Properties

	private var assetsAPIClient = AssetsAPIMockClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Inintializers

	init() {
		getCoinPortfolio()
		getHistoryList()
	}

	// MARK: - public Methods

	public func refreshCoinInfoData(completion: @escaping (APIError?) -> Void) {
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
				if path.status == .satisfied {
					self.getCoinPortfolio()
					self.getHistoryList()
					completion(nil)
				} else {
					completion(.unreachable)
				}
				monitor.cancel()
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}

	// MARK: - private Methods

	private func getCoinPortfolio() {
		assetsAPIClient.coinPortfolio().sink { completed in
			switch completed {
			case .finished:
				print("Coin portfolio received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { coinPortfolio in
			self.coinPortfolio = CoinPortfolioViewModel(coinPortfolioModel: coinPortfolio)
		}.store(in: &cancellables)
	}

	private func getHistoryList() {
		assetsAPIClient.coinHistory().sink { completed in
			switch completed {
			case .finished:
				print("Coin history received successfully")
			case let .failure(error):
				print(error)
			}
		} receiveValue: { coinHistoryModelList in
			self.coinHistoryList = coinHistoryModelList.compactMap { CoinHistoryViewModel(coinHistoryModel: $0) }
		}.store(in: &cancellables)
	}
}
