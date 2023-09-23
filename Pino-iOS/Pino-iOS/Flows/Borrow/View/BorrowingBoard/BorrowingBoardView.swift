//
//  BorrowingBoardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/24/23.
//

import Combine
import Foundation

class BorrowingBoradView: AssetsBoardCollectionView {
	// MARK: - Private Properties

	private let borrowingBoardVM: BorrowingBoardViewModel
	private var borrowingBoardDataSource: BorrowingBoardDataSource!
	private var cancellables = Set<AnyCancellable>()

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
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupCollectionView() {
		isLoading = true

		register(UserBorrowingAssetCell.self, forCellWithReuseIdentifier: UserBorrowingAssetCell.cellReuseID)
		register(BorrowableAssetCell.self, forCellWithReuseIdentifier: BorrowableAssetCell.cellReuseID)

		borrowingBoardDataSource = BorrowingBoardDataSource(
			userBorrowingAssets: borrowingBoardVM.userBorrowingTokens,
			borrowableAssets: borrowingBoardVM.borrowableTokens
		)
		dataSource = borrowingBoardDataSource
	}

	private func setupBindings() {
        borrowingBoardVM.$borrowableTokens.compactMap{$0}.sink { borrowableTokens in
			self.borrowingBoardDataSource.borrowableAssets = borrowableTokens
			self.assets = borrowableTokens
			self.isLoading = false
			self.reloadData()
		}.store(in: &cancellables)
	}
}
