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

	public var symbol: String {
		customAsset.symbol
	}

	public var icon: String {
		"unverified_asset"
	}

	public var decimal: String {
		"\(customAsset.decimal)"
	}

	public var balance: String {
		if let balanceOf = customAsset.balance {
			let userBalanceOfCustomToken = BigNumber(
				number: String(describing: balanceOf),
				decimal: Int(customAsset.decimal)!
			)
			return userBalanceOfCustomToken.sevenDigitFormat
		} else {
            return GlobalZeroAmounts.tokenAmount.zeroAmount
		}
	}

	public var contractAddress: String {
		customAsset.id
	}
}
