//
//  SelectAssetVM.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//


protocol SelectAssetVMProtocol {
    var filteredAssetListByAmount: [AssetProtocol?] { get set }
    var filteredAndSearchedAssetList: [AssetProtocol?] { get set }
    func updateFilteredAndSearchedAssetList(searchValue: String)
}
