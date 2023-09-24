//
//  CollateralizingBoardViewModel.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

class CollateralizingBoardViewModel {
	// MARK: - Public Properties

	public let collateralsTitleText = "collaterals"
	public let borrowVM: BorrowViewModel
	public var userCollateralizingTokens: [UserCollateralizingAssetViewModel]!
	#warning("this is mock")
	public var collateralizableTokens: [CollateralizableAssetViewModel] = []

	// MARK: - Initializers

	init(
		borrowVM: BorrowViewModel
	) {
		self.borrowVM = borrowVM

		setUserCollateralizingTokens()
	}

	// MARK: - Private Methods

	private func setUserCollateralizingTokens() {
		userCollateralizingTokens = borrowVM.userBorrowingDetails?.collateralTokens.compactMap {
			UserCollateralizingAssetViewModel(userCollateralizingAssetModel: $0)
		}
	}
}
