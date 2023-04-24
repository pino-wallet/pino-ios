//
//  AssetsAPIMockClient.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/1/23.
//

import Combine
import Foundation

final class AssetsAPIMockClient: AssetsAPIService {
	// MARK: Public Methods

	public func assets() -> AnyPublisher<Assets, APIError> {
		StubManager.publisher(for: "assets-stub")
	}

	public func positions() -> AnyPublisher<Positions, APIError> {
		StubManager.publisher(for: "positions-stub")
	}

	public func coinHistory() -> AnyPublisher<[CoinHistoryModel], APIError> {
		StubManager.publisher(for: "coin-history-stub")
	}

	public func coinInfoChart() -> AnyPublisher<[AssetChartModel], APIError> {
		StubManager.publisher(for: "coin-info-chart-stub")
	}

	public func aboutCoin() -> AnyPublisher<AboutCoinModel, APIError> {
		StubManager.publisher(for: "about-coin-stub")
	}

	public func performanceInfo() -> AnyPublisher<CoinPerformanceInfoModel, APIError> {
		StubManager.publisher(for: "coin-performance-info-stub")
	}
}
