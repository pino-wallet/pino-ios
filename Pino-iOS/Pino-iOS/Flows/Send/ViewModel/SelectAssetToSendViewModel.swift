//
//  SelectAssetToSendViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Combine

class SelectAssetToSendViewModel: SelectAssetVMProtocol {
	// MARK: - Public Properties
    
    public enum PageStatus {
        case searchEmptyAssets
        case emptyAssets
        case normal
    }

	public let pageTitle = "Select asset"
	public let dissmissIocnName = "dissmiss"

    @Published public var pageStatus: PageStatus = .normal
	@Published
	public var filteredAssetList: [AssetViewModel]
	public var filteredAssetListByAmount: [AssetViewModel]

	// MARK: - initializers

	init(assetsList: [AssetViewModel]) {
		self.filteredAssetListByAmount = assetsList.filter { asset in
			!asset.isPosition
		}
		self.filteredAssetList = filteredAssetListByAmount
        
        updatePageStatusWithDefaultAssets()
	}
    
    // MARK: - Private Properties
    private func updatePageStatusWithDefaultAssets() {
        if filteredAssetListByAmount.isEmpty {
            pageStatus = .emptyAssets
        } else {
            pageStatus = .normal
        }
    }
    
    private func updatePageStatusWithSearchResult() {
        if filteredAssetList.isEmpty {
            pageStatus = .searchEmptyAssets
        } else {
            pageStatus = .normal
        }
    }

	// MARK: - Public Methods

	public func updateFilteredAndSearchedAssetList(searchValue: String) {
		let searchValueLowerCased = searchValue.lowercased()
		if !searchValue.isEmpty {
			filteredAssetList = filteredAssetListByAmount
				.filter { asset in
					asset.name.lowercased().contains(searchValueLowerCased) ||
						asset.symbol.lowercased().contains(searchValueLowerCased)
				}
            updatePageStatusWithSearchResult()
		} else {
			filteredAssetList = filteredAssetListByAmount
            updatePageStatusWithDefaultAssets()
		}
	}
}
