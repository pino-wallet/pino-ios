//
//  SelectAssetToSendViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Combine

class SelectAssetToSendViewModel: SelectAssetVMProtocol {
	// MARK: - Public Properties

	public let pageTitle = "Select asset"
	public let dissmissIocnName = "dissmiss"

	@Published
	var filteredAndSearchedAssetList: [AssetProtocol?]
	var filteredAssetListByAmount: [AssetProtocol?]

	// MARK: - initializers

	init(assetsList: [AssetProtocol?]) {
		self.filteredAssetListByAmount = assetsList.filter { !BigNumber(number: $0!.amount, decimal: 6).isZero }
		self.filteredAndSearchedAssetList = filteredAssetListByAmount
	}

	// MARK: - Public Methods

	public func updateFilteredAndSearchedAssetList(searchValue: String) {
		let searchValueLowerCased = searchValue.lowercased()
		if !searchValue.isEmpty {
			filteredAndSearchedAssetList = filteredAssetListByAmount
				.filter { $0?.detail?.name.lowercased().contains(searchValueLowerCased) ?? false }
		} else {
			filteredAndSearchedAssetList = filteredAssetListByAmount
		}
	}
}
