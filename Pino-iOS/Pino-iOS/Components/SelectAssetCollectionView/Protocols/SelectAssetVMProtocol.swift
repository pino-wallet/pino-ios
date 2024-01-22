//
//  SelectAssetVM.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

protocol SelectAssetVMProtocol {
	var filteredAssetListByAmount: [AssetViewModel] { get set }
	var filteredAssetList: [AssetViewModel] { get set }
	func updateFilteredAndSearchedAssetList(searchValue: String)
}
