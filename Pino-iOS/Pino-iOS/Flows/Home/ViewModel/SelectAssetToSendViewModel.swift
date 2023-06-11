//
//  SelectAssetToSendViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

class SelectAssetToSendViewModel: SelectAssetVMProtocol {
    // MARK: - Public Properties
    public let pageTitle = "Select asset"
    public let dissmissIocnName = "dissmiss"
    
    
    var filteredAssetListByAmount: [AssetProtocol?]
    
    
    // MARK: - initializers
    init(assetsList: [AssetProtocol?]) {
        filteredAssetListByAmount = assetsList.filter({ BigNumber(number: $0!.amount, decimal: 6).isZero })
    }
}
