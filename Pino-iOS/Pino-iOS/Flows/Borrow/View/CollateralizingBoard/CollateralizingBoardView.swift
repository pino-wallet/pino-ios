//
//  CollateralizingBoardView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/26/23.
//

import Foundation

class CollateralizingBoradView: AssetsBoardCollectionView {
    // MARK: - Private Properties

    private var collateralizingBoardDataSource: CollateralizingBoardDataSource!
    private let collateralizingBoardVM: CollateralizingBoardViewModel

    // MARK: - Initializers

    init(
        collateralizingBoardVM: CollateralizingBoardViewModel,
        assetDidSelect: @escaping (AssetsBoardProtocol) -> Void
    ) {
        self.collateralizingBoardVM = collateralizingBoardVM
        super.init(
            assets: collateralizingBoardVM.userCollateralizingTokens,
            userAssets: collateralizingBoardVM.collateralizableTokens,
            assetDidSelect: assetDidSelect
        )
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupCollectionView() {
        register(UserCollateralizingAssetCell.self, forCellWithReuseIdentifier: UserCollateralizingAssetCell.cellReuseID)
        register(CollateralizableAssetCell.self, forCellWithReuseIdentifier: CollateralizableAssetCell.cellReuseID)

        collateralizingBoardDataSource = CollateralizingBoardDataSource(
            userCollateralizingAssets: collateralizingBoardVM.userCollateralizingTokens,
            collateralizableAssets: collateralizingBoardVM.collateralizableTokens
        )
        dataSource = collateralizingBoardDataSource
    }
}
