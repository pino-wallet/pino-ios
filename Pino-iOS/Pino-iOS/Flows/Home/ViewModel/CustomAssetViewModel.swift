//
//  CustomAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/15/23.
//

struct CustomAssetViewModel {
	// MARK: - Public Properties

	public var customAsset: CustomAssetModel

	public var name: String {
		customAsset.name
	}

	public var icon: String {
		customAsset.icon
	}

	public var balance: String? {
		customAsset.balance
	}

	public var website: String {
		customAsset.website
	}

	public var contractAddress: String {
		customAsset.contractAddress
	}
}
