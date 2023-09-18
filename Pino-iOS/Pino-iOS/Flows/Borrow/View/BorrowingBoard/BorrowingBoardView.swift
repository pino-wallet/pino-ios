//
//  BorrowingBoardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Foundation

class BorrowingBoradView: AssetsBoardCollectionView {
	// MARK: - Private Properties

	private var borrowingBoardDataSource: BorrowingBoardDataSource!
	private let borrowingBoardVM: BorrowingBoardViewModel

	// MARK: - Initializers

	init(
		borrowingBoardVM: BorrowingBoardViewModel,
		assetDidSelect: @escaping (AssetsBoardProtocol) -> Void
	) {
		self.borrowingBoardVM = borrowingBoardVM
		super.init(
			assets: borrowingBoardVM.borrowableTokens ?? [],
			userAssets: borrowingBoardVM.userBorrowingTokens,
			assetDidSelect: assetDidSelect
		)
		setupCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupCollectionView() {
		register(UserBorrowingAssetCell.self, forCellWithReuseIdentifier: UserBorrowingAssetCell.cellReuseID)
		register(BorrowableAssetCell.self, forCellWithReuseIdentifier: BorrowableAssetCell.cellReuseID)

		borrowingBoardDataSource = BorrowingBoardDataSource(
			userBorrowingAssets: borrowingBoardVM.userBorrowingTokens,
			borrowableAssets: borrowingBoardVM.borrowableTokens
		)
		dataSource = borrowingBoardDataSource
	}
}
