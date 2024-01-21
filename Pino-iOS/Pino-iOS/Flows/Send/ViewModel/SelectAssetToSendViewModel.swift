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
	var filteredAssetList: [AssetViewModel?]
	var filteredAssetListByAmount: [AssetViewModel?]

	// MARK: - initializers

	init(assetsList: [AssetViewModel?]) {
        self.filteredAssetListByAmount = assetsList.filter { asset in
            !asset!.isPosition
        }
		self.filteredAssetList = filteredAssetListByAmount
	}

	// MARK: - Public Methods

	public func updateFilteredAndSearchedAssetList(searchValue: String) {
		let searchValueLowerCased = searchValue.lowercased()
		if !searchValue.isEmpty {
			filteredAssetList = filteredAssetListByAmount
				.filter {
					guard let asset = $0 else { return false }
					return asset.name.lowercased().contains(searchValueLowerCased) ||
						asset.symbol.lowercased().contains(searchValueLowerCased)
				}
		} else {
			filteredAssetList = filteredAssetListByAmount
		}
	}
}
