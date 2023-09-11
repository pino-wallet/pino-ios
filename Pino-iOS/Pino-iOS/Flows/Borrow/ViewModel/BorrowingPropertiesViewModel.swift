//
//  BorrowingPropertiesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//

import UIKit


struct BorrowingPropertiesViewModel {
	// MARK: - Public Properties

	//    public var globalAssetsList: [AssetViewModel]
	public var borrowingAssetsList: [UserBorrowingToken]?
	public var prevBorrowingAssetsList: [UserBorrowingToken] = []
	public var progressBarColor: UIColor

	public var borrowingAmount: String {
		guard let borrowingAssetsList, !borrowingAssetsList.isEmpty else {
			return "0"
		}
		#warning("this is mock")
		return "$88"
	}

	#warning("this is mock and we should return a complete assetDetails with percentageOfTotalShare and asset icon")
	public var borrowingAssetsDetailList: [BorrowingTokenModel]? {
		guard let borrowingAssetsList else {
			return nil
		}
		return borrowingAssetsList.compactMap { newToken in
			let foundTokenInPrevBorrowingTokens = prevBorrowingAssetsList.first(where: { $0.id == newToken.id })
			if foundTokenInPrevBorrowingTokens != nil {
				return BorrowingTokenModel(
					tokenImage: "USDC",
					tokenSharedBorrowingPercentage: 31.1,
					prevTokenSharedBorrowingPercentage: 73.4
				)
			} else {
				return BorrowingTokenModel(
					tokenImage: "USDC",
					tokenSharedBorrowingPercentage: 73.4,
					prevTokenSharedBorrowingPercentage: 0
				)
			}
		}
	}
}
