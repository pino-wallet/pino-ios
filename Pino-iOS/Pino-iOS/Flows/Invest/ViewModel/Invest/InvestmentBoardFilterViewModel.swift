//
//  InvestmentBoardFilterViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

struct InvestmentBoardFilterViewModel {
	// MARK: - Public Properties

	public var filters: [InvestmentFilterItemViewModel]!

	public var selectedAsset: AssetViewModel?
	public var selectedProtocol: InvestProtocolViewModel?
	public var selectedRisk: String?

	public var filterDelegate: InvestFilterDelegate

	// MARK: - Initializers

	init(
		selectedAsset: AssetViewModel?,
		selectedProtocol: InvestProtocolViewModel?,
		selectedRisk: String?,
		filterDelegate: InvestFilterDelegate
	) {
		self.selectedAsset = selectedAsset
		self.selectedProtocol = selectedProtocol
		self.selectedRisk = selectedRisk
		self.filterDelegate = filterDelegate
		setupFilterItems()
	}

	// MARK: - Private Methods

	private mutating func setupFilterItems() {
		filters = [
			InvestmentFilterItemViewModel(item: .assets, description: selectedAsset?.name),
			InvestmentFilterItemViewModel(item: .investProtocol, description: selectedProtocol?.protocolInfo.name),
			InvestmentFilterItemViewModel(item: .risk, description: selectedRisk),
		]
	}

	// MARK: - Public Methods

	public mutating func applyFilters() {
		filterDelegate.filterUpdated(
			assetFilter: selectedAsset,
			protocolFilter: selectedProtocol,
			riskFilter: selectedRisk
		)
	}
}
