//
//  SelectAssetCellProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import Foundation

protocol SelectAssetCellVMProtocol {
    var assetModel: AssetProtocol { get set }
    var assetName: String { get }
    var assetSymbol: String { get }
    var assetAmount: String { get }
    var assetLogo: URL! { get }
}
