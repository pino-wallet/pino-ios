//
//  SelectAssetCellViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Foundation

class SelectAssetCellViewModel: SelectAssetCellVMProtocol {
    // MARK: - Public Properties
    
    var assetModel: AssetProtocol
    
    var assetName: String {
        return assetModel.detail?.name ?? ""
    }
    
    var assetSymbol: String {
        return assetModel.detail?.symbol ?? ""
    }
    
    var assetAmount: String {
        return BigNumber(number: assetModel.amount, decimal: 6).description
    }
    
    var assetLogo: URL! {
        return URL(string: assetModel.detail!.logo)
    }
    
    // MARK: - Initializers
    init(assetModel: AssetProtocol) {
        self.assetModel = assetModel
    }
}
