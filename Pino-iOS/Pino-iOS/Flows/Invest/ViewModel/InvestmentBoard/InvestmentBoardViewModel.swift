//
//  InvestmentBoardViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import Combine
import Foundation

class InvestmentBoardViewModel: InvestFilterDelegate {
	// MARK: - Private Properties

	private let investmentAPIClient = InvestmentAPIClient()
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public Properties

	public let userInvestmentsTitle = "My investments"
	public let investableAssetsTitle = "Investable assets"
	public var userInvestments = [InvestAssetViewModel]()
	public var investableAssets = [InvestableAssetViewModel]()
	@Published
	public var filteredAssets: [InvestableAssetViewModel]?

	public var assetFilter: AssetViewModel?
	public var protocolFilter: InvestProtocolViewModel?
	public var riskFilter: InvestmentRisk?

	// MARK: - Initializers

	init(userInvestments: [InvestAssetViewModel]) {
		self.userInvestments = userInvestments
		getInvestableAssets()
	}

	// MARK: - Private Methods

	private func getInvestableAssets() {
		investmentAPIClient.investableAssets().sink { completed in
			switch completed {
			case .finished:
				print("Investable assets received successfully")
			case let .failure(error):
				print("Error getting investable assets:\(error)")
			}
		} receiveValue: { investableAssetsModel in
			self.investableAssets = investableAssetsModel.compactMap { InvestableAssetViewModel(assetModel: $0) }
			self.filteredAssets = self.investableAssets
		}.store(in: &cancellables)
	}

	private func getTokenPositionID(
		investableAsset: InvestableAssetViewModel,
		completion: @escaping (String) -> Void
	) {
		let w3APIClient = Web3APIClient()
		w3APIClient.getTokenPositionID(
			tokenAdd: investableAsset.tokenId.lowercased(),
			positionType: .investment,
			protocolName: investableAsset.assetProtocol.rawValue
		).sink { completed in
			switch completed {
			case .finished:
				print("Position id received successfully")
			case let .failure(error):
				print("Error getting position id:\(error)")
			}
		} receiveValue: { tokenPositionModel in
			completion(tokenPositionModel.positionID.lowercased())
		}.store(in: &cancellables)
	}

	// MARK: - Internal Methods

	internal func filterUpdated(
		assetFilter: AssetViewModel?,
		protocolFilter: InvestProtocolViewModel?,
		riskFilter: InvestmentRisk?
	) {
		self.assetFilter = assetFilter
		self.protocolFilter = protocolFilter
		self.riskFilter = riskFilter

		var filteringAssets = investableAssets
		if let assetFilter {
			filteringAssets = filteringAssets.filter { $0.assetName == assetFilter.symbol }
		}
		if let protocolFilter {
			filteringAssets = filteringAssets.filter { $0.assetProtocol.type == protocolFilter.type }
		}
		if let riskFilter {
			filteringAssets = filteringAssets.filter { $0.investmentRisk == riskFilter }
		}

		filteredAssets = filteringAssets
	}

	// MARK: - Public Methods

	public func checkOpenPosition(
		selectedAsset: InvestableAssetViewModel,
		completion: @escaping (Bool) -> Void
	) {
		getTokenPositionID(investableAsset: selectedAsset) { positionId in
			if selectedAsset.investToken.isPosition, selectedAsset.investToken.holdAmount > 0.bigNumber {
				completion(true)
			} else {
				completion(false)
			}
		}
	}
}
