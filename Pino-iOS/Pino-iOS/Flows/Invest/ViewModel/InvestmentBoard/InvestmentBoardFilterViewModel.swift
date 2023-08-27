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
	public var selectedRisk: InvestmentRisk?

	public var filterDelegate: InvestFilterDelegate

	// MARK: - Initializers

	init(
		selectedAsset: AssetViewModel?,
		selectedProtocol: InvestProtocolViewModel?,
		selectedRisk: InvestmentRisk?,
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
			InvestmentFilterItemViewModel(item: .investProtocol, description: selectedProtocol?.name),
			InvestmentFilterItemViewModel(item: .risk, description: selectedRisk?.title),
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

	public func updateFilter(selectedAsset: AssetViewModel?) {
		self.selectedAsset = selectedAsset
		let assetFilterIndex = filters.firstIndex(where: { $0.filterItem == .assets })!
		if let selectedAsset {
			filters[assetFilterIndex].updateDescription(selectedAsset.name)
		} else {
			filters[assetFilterIndex].updateDescription("All")
		}
	}

	public func updateFilter(selectedProtocol: InvestProtocolViewModel?) {
		self.selectedProtocol = selectedProtocol
		let protocolFilterIndex = filters.firstIndex(where: { $0.filterItem == .investProtocol })!
		if let selectedProtocol {
			filters[protocolFilterIndex].updateDescription(selectedProtocol.name)
		} else {
			filters[protocolFilterIndex].updateDescription("All")
		}
	}

	public func updateFilter(selectedRisk: InvestmentRisk?) {
		self.selectedRisk = selectedRisk
		let riskFilterIndex = filters.firstIndex(where: { $0.filterItem == .risk })!
		if let selectedRisk {
			filters[riskFilterIndex].updateDescription(selectedRisk.title)
		} else {
			filters[riskFilterIndex].updateDescription("All")
		}
	}

	public func clearFilters() {
		updateFilter(selectedAsset: nil)
		updateFilter(selectedProtocol: nil)
		updateFilter(selectedRisk: nil)
	}
}
