//
//  BorrowableAssetViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

struct BorrowableAssetViewModel: AssetsBoardProtocol {
	// MARK: - Private Properties

	private var borrowableTokenModel: BorrowableTokenModel

	// MARK: - Public Properties

	public var assetName: String {
		foundTokenInManageAssetTokens.symbol
	}

	public var assetImage: URL {
		foundTokenInManageAssetTokens.image
	}

	public var APYAmount: BigNumber {
		borrowableTokenModel.apy.bigNumber
	}

	public var formattedAPYAmount: String {
		"%\(APYAmount.percentFormat)"
	}

	public var volatilityType: AssetVolatilityType {
		AssetVolatilityType(change24h: APYAmount)
	}

	// MARK: - Private Properties

	private var foundTokenInManageAssetTokens: AssetViewModel {
		(GlobalVariables.shared.manageAssetsList?.first(where: { $0.id == borrowableTokenModel.tokenID }))!
	}

	// MARK: - Initializers

	init(borrowableTokenModel: BorrowableTokenModel) {
		self.borrowableTokenModel = borrowableTokenModel
	}
}
