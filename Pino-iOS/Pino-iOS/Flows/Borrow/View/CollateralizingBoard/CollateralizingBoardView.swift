//
//  CollateralizingBoardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Combine
import Foundation

class CollateralizingBoradView: AssetsBoardCollectionView {
	// MARK: - Private Properties

	private let collateralizingBoardVM: CollateralizingBoardViewModel
	private var collateralizingBoardDataSource: CollateralizingBoardDataSource!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		collateralizingBoardVM: CollateralizingBoardViewModel,
		assetDidSelect: @escaping (AssetsBoardProtocol) -> Void
	) {
		self.collateralizingBoardVM = collateralizingBoardVM
		super.init(
			assets: collateralizingBoardVM.collateralizableTokens ?? [],
			userAssets: collateralizingBoardVM.userCollateralizingTokens,
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

		register(
			UserCollateralizingAssetCell.self,
			forCellWithReuseIdentifier: UserCollateralizingAssetCell.cellReuseID
		)
		register(CollateralizableAssetCell.self, forCellWithReuseIdentifier: CollateralizableAssetCell.cellReuseID)

		collateralizingBoardDataSource = CollateralizingBoardDataSource(
			userCollateralizingAssets: collateralizingBoardVM.userCollateralizingTokens,
			collateralizableAssets: collateralizingBoardVM.collateralizableTokens
		)
		dataSource = collateralizingBoardDataSource
	}

	private func setupBindings() {
		collateralizingBoardVM.$collateralizableTokens.compactMap { $0 }.sink { collateralizableTokens in
			self.collateralizingBoardDataSource.collateralizableAssets = collateralizableTokens
			self.assets = collateralizableTokens
			self.isLoading = false
			self.reloadData()
		}.store(in: &cancellables)
	}
}
