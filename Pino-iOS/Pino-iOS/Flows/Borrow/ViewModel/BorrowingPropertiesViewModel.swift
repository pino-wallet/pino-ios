//
//  BorrowingPropertiesViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/20/23.
//

import UIKit

struct BorrowingPropertiesViewModel {
	// MARK: - Private Properties

	private var globalAssetsList: [AssetViewModel]?
	private var totalBorrowingAmountInDollars: BigNumber {
		var totalAmount = 0.bigNumber
		guard let borrowingAssetsList, !borrowingAssetsList.isEmpty else {
			return totalAmount
		}
		for userBorrowingAsset in borrowingAssetsList {
			guard let foundToken = globalAssetsList?.first(where: { $0.id == userBorrowingAsset.id }) else {
				return totalAmount
			}
			let tokenAmount = BigNumber(number: userBorrowingAsset.amount, decimal: foundToken.decimal)
			let tokenAmountInDollars = tokenAmount * foundToken.price
			totalAmount = totalAmount + tokenAmountInDollars
		}
		return totalAmount
	}

	// MARK: - Public Properties

	public var borrowingAssetsList: [UserBorrowingToken]?
	public var prevBorrowingAssetsList: [UserBorrowingToken]
	public var progressBarColor: UIColor

	public var formattedBorrowingAmountInDollars: String {
		guard let borrowingAssetsList, !borrowingAssetsList.isEmpty else {
			return "0"
		}

		return totalBorrowingAmountInDollars.priceFormat(of: .coin, withRule: .standard)
	}

	public var borrowingAssetsDetailList: [BorrowingTokenModel]? {
		guard let borrowingAssetsList else {
			return nil
		}
		return borrowingAssetsList.compactMap { newToken in
			guard let foundTokenInManageAssets = globalAssetsList?.first(where: { $0.id == newToken.id }) else {
				return nil
			}
			let foundTokenInPrevBorrowingTokens = prevBorrowingAssetsList.first(where: { $0.id == newToken.id })
			if foundTokenInPrevBorrowingTokens != nil {
				return BorrowingTokenModel(
					tokenImage: foundTokenInManageAssets.image,
					tokenSharedBorrowingPercentage: getTokenSharedBorrowingPercentage(
						token: newToken,
						foundTokenInManageAssets: foundTokenInManageAssets
					),
					prevTokenSharedBorrowingPercentage: getTokenSharedBorrowingPercentage(
						token: foundTokenInPrevBorrowingTokens!,
						foundTokenInManageAssets: foundTokenInManageAssets
					)
				)
			} else {
				return BorrowingTokenModel(
					tokenImage: foundTokenInManageAssets.image,
					tokenSharedBorrowingPercentage: getTokenSharedBorrowingPercentage(
						token: newToken,
						foundTokenInManageAssets: foundTokenInManageAssets
					),
					prevTokenSharedBorrowingPercentage: 0.bigNumber
				)
			}
		}
	}

	// MARK: - Initializers

	init(
		borrowingAssetsList: [UserBorrowingToken]? = nil,
		prevBorrowingAssetsList: [UserBorrowingToken] = [],
		progressBarColor: UIColor = .Pino.white,
		globalAssetsList: [AssetViewModel]? = nil
	) {
		self.borrowingAssetsList = borrowingAssetsList
		self.prevBorrowingAssetsList = prevBorrowingAssetsList
		self.progressBarColor = progressBarColor
		self.globalAssetsList = globalAssetsList
	}

	// MARK: - Private Methods

	private func getTokenSharedBorrowingPercentage(
		token: UserBorrowingToken,
		foundTokenInManageAssets: AssetViewModel
	) -> BigNumber {
		let amountPercentage = totalBorrowingAmountInDollars / 100.bigNumber ?? 0.bigNumber
		let tokenAmount = BigNumber(number: token.amount, decimal: foundTokenInManageAssets.decimal)
		let tokenAmountInDollars = tokenAmount * foundTokenInManageAssets.price
		return tokenAmountInDollars / amountPercentage ?? 0.bigNumber
	}
}
