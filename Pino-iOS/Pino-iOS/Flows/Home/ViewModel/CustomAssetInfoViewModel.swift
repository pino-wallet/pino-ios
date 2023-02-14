//
//  CustomAssetPropertyViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/15/23.
//

struct CustomAssetInfoViewModel {
	public let customAssetInfo: CustomAssetInfoModel

	public var title: String {
		customAssetInfo.title
	}

	public var alertText: String {
		customAssetInfo.alertText
	}
}
