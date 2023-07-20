//
//  ActivityDetailsProtocol.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/20/23.
//

protocol ActivityDetailsProtocol {
    var activityModel: ActivityModel { get set }
    var globalAssetsList: [AssetViewModel] { get }
}