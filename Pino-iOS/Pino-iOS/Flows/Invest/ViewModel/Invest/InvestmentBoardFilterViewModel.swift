//
//  InvestmentBoardFilterViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

class InvestmentBoardFilterViewModel {
	// MARK: - Public Properties

	@Published
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

	private func setupFilterItems() {
		filters = [
			InvestmentFilterItemViewModel(item: .assets, description: selectedAsset?.name),
			InvestmentFilterItemViewModel(item: .investProtocol, description: selectedProtocol?.protocolInfo.name),
			InvestmentFilterItemViewModel(item: .risk, description: selectedRisk),
		]
	}

	// MARK: - Public Methods

	public func applyFilters() {
		filterDelegate.filterUpdated(
			assetFilter: selectedAsset,
			protocolFilter: selectedProtocol,
			riskFilter: selectedRisk
		)
	}

	public func updateFilter(selectedAsset: AssetViewModel) {
		self.selectedAsset = selectedAsset
		let assetFilterIndex = filters.firstIndex(where: { $0.filterItem == .assets })!
		filters[assetFilterIndex].updateDescription(selectedAsset.name)
	}

	public func updateFilter(selectedProtocol: InvestProtocolViewModel) {
		self.selectedProtocol = selectedProtocol
		let protocolFilterIndex = filters.firstIndex(where: { $0.filterItem == .investProtocol })!
		filters[protocolFilterIndex].updateDescription(selectedProtocol.protocolInfo.name)
	}

	public func updateFilter(selectedRisk: String) {
		self.selectedRisk = selectedRisk
		let riskFilterIndex = filters.firstIndex(where: { $0.filterItem == .risk })!
		filters[riskFilterIndex].updateDescription(selectedRisk)
	}
}
