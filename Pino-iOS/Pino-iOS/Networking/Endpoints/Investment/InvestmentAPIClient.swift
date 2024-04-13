//
//  InvestmentAPIClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/12/23.
//

import Combine
import Foundation

final class InvestmentAPIClient: InvestmentAPIService {
	// MARK: - Private Properties

	private let networkManager = NetworkManager<InvestmentEndpoint>()
	private let pinoWalletManager = PinoWalletManager()
	private var currentAccountAddress: String {
		pinoWalletManager.currentAccount.eip55Address
	}

	// MARK: - Public Methods

	func investableAssets() -> AnyPublisher<[InvestableAssetsModel], APIError> {
		networkManager.request(.investableAssets)
	}

	func investments() -> AnyPublisher<[InvestmentModel], APIError> {
		networkManager.request(.investment(accountAddress: currentAccountAddress))
	}

	func investOverallPortfolio() -> AnyPublisher<[ChartDataModel], APIError> {
		networkManager.request(.investOverallPortfolio(accountAddress: currentAccountAddress))
	}

	func investPortfolio(timeFrame: String) -> AnyPublisher<[ChartDataModel], APIError> {
		networkManager.request(.investPortfolio(timeFrame: timeFrame, accountAddress: currentAccountAddress))
	}

	func investmentPerformance(timeFrame: String, investmentID: String) -> AnyPublisher<[ChartDataModel], APIError> {
		networkManager
			.request(.investmentPerformance(
				timeFrame: timeFrame,
				investmentID: investmentID,
				accountAddress: currentAccountAddress
			))
	}

	func investmentDetail(address: String, investmentID: String) -> AnyPublisher<InvestmentDetailModel, APIError> {
		networkManager.request(.investmentDetail(accountAddress: currentAccountAddress, investmentID: investmentID))
	}

	func investmentListingInfo(listingId: String) -> AnyPublisher<[InvestableAssetsModel], APIError> {
		networkManager.request(.investmentListingInfo(investmentId: listingId))
	}
}
