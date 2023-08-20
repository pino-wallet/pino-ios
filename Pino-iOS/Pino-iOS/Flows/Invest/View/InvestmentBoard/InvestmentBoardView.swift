//
//  InvestmentBoardCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import UIKit

class InvestmentBoardView: AssetsBoardCollectionView {
	// MARK: - Private Properties

	private let investmentDataSource: InvestmentBoardDataSource

	// MARK: - Initializers

	init(
		investmentBoardVM: InvestmentBoardViewModel,
		assetDidSelect: @escaping (AssetsBoardProtocol) -> Void,
		filterDidTap: @escaping () -> Void
	) {
		self.investmentDataSource = InvestmentBoardDataSource(
			investmentVM: investmentBoardVM,
			filterDidTap: filterDidTap
		)
		super.init(
			assets: investmentBoardVM.investableAssets,
			userAssets: investmentBoardVM.userInvestments,
			assetDidSelect: assetDidSelect
		)
		setupCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupCollectionView() {
		register(UserInvestmentAssetCell.self, forCellWithReuseIdentifier: UserInvestmentAssetCell.cellReuseID)
		register(InvestableAssetCell.self, forCellWithReuseIdentifier: InvestableAssetCell.cellReuseID)
		dataSource = investmentDataSource
	}
}
