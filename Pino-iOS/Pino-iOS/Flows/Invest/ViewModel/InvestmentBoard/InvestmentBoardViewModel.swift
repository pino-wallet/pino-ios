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

		var filteringAssets = investableAssets.filter { asset in
			if self.userInvestments.contains(where: { $0.listId.lowercased() == asset.id.lowercased() }) {
				return false
			} else {
				return true
			}
		}
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

	public func getInvestableAssets() {
		investmentAPIClient.investableAssets().sink { completed in
			switch completed {
			case .finished:
				print("Investable assets received successfully")
			case let .failure(error):
				print("Error getting investable assets:\(error)")
			}
		} receiveValue: { investableAssetsModel in
			let investableAssets = investableAssetsModel.compactMap { InvestableAssetViewModel(assetModel: $0) }
			self.investableAssets = investableAssets
			self.filteredAssets = investableAssets.filter { asset in
				if self.userInvestments.contains(where: { $0.listId.lowercased() == asset.id.lowercased() }) {
					return false
				} else {
					return true
				}
			}
		}.store(in: &cancellables)
	}

	public func getApy(of selectedAsset: InvestAssetViewModel) -> BigNumber {
		let selectedInvestmentInfo = investableAssets.first(
			where: { $0.id.lowercased() == selectedAsset.listId.lowercased() }
		)!
		return selectedInvestmentInfo.APYAmount
	}
}
