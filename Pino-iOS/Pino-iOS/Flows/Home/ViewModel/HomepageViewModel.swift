//
//  HomepageViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import Combine
import Foundation
import Network

class HomepageViewModel {
	// MARK: - Public Properties

	@Published
	public var walletInfo: WalletInfoModel!
	@Published
	public var walletBalance: WalletBalanceModel!
	@Published
	public var assetsList: [AssetViewModel]!
	@Published
	public var positionAssetsList: [AssetViewModel]!

	public let copyToastMessage = "Copied!"
	public let connectionErrorToastMessage = "No internet connection"
	public let requestFailedErrorToastMessage = "Couldn't refresh home data"
	public let sendButtonTitle = "Send"
	public let recieveButtonTitle = "Recieve"
	public let sendButtonImage = "arrow.up"
	public let recieveButtonImage = "arrow.down"

	// MARK: - Initializers

	init() {
		getWalletInfo()
		getWalletBalance()
		getAssetsList()
		getPositionAssetsList()
	}

	// MARK: - Public Methods

	public func refreshHomeData(completion: @escaping (HomeRefreshError?) -> Void) {
		// This is temporary and must be replaced with network request
		let monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				if path.status == .satisfied {
					self.getWalletBalance()
					self.getAssetsList()
					self.getPositionAssetsList()
					completion(nil)
					monitor.cancel()
				} else {
					completion(.networkConnection)
					monitor.cancel()
				}
			}
		}
		let queue = DispatchQueue(label: "InternetConnectionMonitor")
		monitor.start(queue: queue)
	}

	// MARK: - Private Methods

	private func getWalletInfo() {
		// Request to get wallet info
		let walletModel = WalletInfoModel(
			name: "Amir",
			address: "gf4bh5n3m2c8l4j5w9i2l6t2de",
			profileImage: "avocado",
			profileColor: "Green 1 Color"
		)
		walletInfo = walletModel
	}

	private func getWalletBalance() {
		// Request to get balance
		let balanceModel = WalletBalanceModel(
			balance: "$12,568,000",
			volatilityPercentage: "+5.6%",
			volatilityInDollor: "+$58.67",
			volatilityType: .profit
		)
		walletBalance = balanceModel
	}

	private func getAssetsList() {
		let assetsModel = [
			AssetModel(
				image: "Chainlink",
				name: "Chainlink",
				codeName: "Link",
				amount: "10,04",
				amountInDollor: "1,530",
				volatility: "10",
				volatilityType: .profit
			),
			AssetModel(
				image: "Ribon",
				name: "Ribon",
				codeName: "RBN",
				amount: "4,330",
				amountInDollor: "1,530",
				volatility: "115",
				volatilityType: .profit
			),
			AssetModel(
				image: "Tether",
				name: "Tether",
				codeName: "USDT",
				amount: "1.049",
				amountInDollor: "1,530",
				volatility: "3.5",
				volatilityType: .loss
			),
			AssetModel(
				image: "BTC",
				name: "BTC",
				codeName: "BTC",
				amount: nil,
				amountInDollor: nil,
				volatility: nil,
				volatilityType: nil
			),
		]

		assetsList = assetsModel.compactMap { AssetViewModel(assetModel: $0) }
	}

	private func getPositionAssetsList() {
		let assetsModel = [
			AssetModel(
				image: "cETH",
				name: "cETH",
				codeName: "ETH",
				amount: "1.2",
				amountInDollor: "1,530",
				volatility: "10",
				volatilityType: .profit
			),
			AssetModel(
				image: "aDAI",
				name: "aDAI",
				codeName: "aDAI",
				amount: "10.2",
				amountInDollor: "10,3",
				volatility: "14",
				volatilityType: .profit
			),
			AssetModel(
				image: "Sand",
				name: "Sand",
				codeName: "SAND",
				amount: "10,04",
				amountInDollor: "1,530",
				volatility: "10",
				volatilityType: .profit
			),
			AssetModel(
				image: "Status",
				name: "Status",
				codeName: "SNT",
				amount: "4,330",
				amountInDollor: "1,530",
				volatility: "115",
				volatilityType: .profit
			),
			AssetModel(
				image: "DAI",
				name: "DAI",
				codeName: "DAI",
				amount: "1.049",
				amountInDollor: "1,530",
				volatility: "3.5",
				volatilityType: .loss
			),
			AssetModel(
				image: "USDC",
				name: "USDC",
				codeName: "USDC",
				amount: nil,
				amountInDollor: nil,
				volatility: nil,
				volatilityType: nil
			),
		]

		positionAssetsList = assetsModel.compactMap { AssetViewModel(assetModel: $0) }
	}
}
