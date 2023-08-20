//
//  InvestmentBoardFilterViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/20/23.
//

import Foundation

struct InvestmentBoardFilterViewModel {
	// MARK: - Public Properties

	public var filters: [InvestmentFilterItemViewModel]

	public var selectedAsset: AssetViewModel?
	public var selectedProtocol: InvestProtocolViewModel?
	public var selectedRisk: String?

	// MARK: - Initializers

	init(
		selectedAsset: AssetViewModel? = nil,
		selectedProtocol: InvestProtocolViewModel? = nil,
		selectedRisk: String? = nil
	) {
		self.filters = [
			InvestmentFilterItemViewModel(item: .assets, description: selectedAsset?.name),
			InvestmentFilterItemViewModel(item: .investProtocol, description: selectedProtocol?.protocolInfo.name),
			InvestmentFilterItemViewModel(item: .risk, description: selectedRisk),
		]
	}
}
