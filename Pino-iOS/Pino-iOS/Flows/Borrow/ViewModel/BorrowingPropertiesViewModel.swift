//
//  BorrowingPropertiesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//

struct BorrowingPropertiesViewModel {
	// MARK: - Public Properties

	//    public var globalAssetsList: [AssetViewModel]
	public var borrowingAssetsList: [UserBorrowingToken]

	public var borrowingAmount: String {
		if borrowingAssetsList.isEmpty {
			return "0"
		} else {
			#warning("this is mock")
			return "$88"
		}
	}

	#warning("this is mock and we should return a complete assetDetails with percentageOfTotalShare and asset icon")
	public var borrowingAssetsDetailList: [UserBorrowingToken] {
		borrowingAssetsList
	}
}
