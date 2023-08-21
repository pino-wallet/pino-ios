//
//  InvestmentBoardCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/16/23.
//

import Combine
import UIKit

class InvestmentBoardView: AssetsBoardCollectionView {
	// MARK: - Private Properties

	private var investmentDataSource: InvestmentBoardDataSource!
	private let investmentBoardVM: InvestmentBoardViewModel
	private let filterDidTap: () -> Void
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		investmentBoardVM: InvestmentBoardViewModel,
		assetDidSelect: @escaping (AssetsBoardProtocol) -> Void,
		filterDidTap: @escaping () -> Void
	) {
		self.investmentBoardVM = investmentBoardVM
		self.filterDidTap = filterDidTap
		super.init(
			assets: investmentBoardVM.investableAssets,
			userAssets: investmentBoardVM.userInvestments,
			assetDidSelect: assetDidSelect
		)
		setupCollectionView()
		setupBinding()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupCollectionView() {
		register(UserInvestmentAssetCell.self, forCellWithReuseIdentifier: UserInvestmentAssetCell.cellReuseID)
		register(InvestableAssetCell.self, forCellWithReuseIdentifier: InvestableAssetCell.cellReuseID)

		investmentDataSource = InvestmentBoardDataSource(
			userInvestments: investmentBoardVM.userInvestments,
			investableAssets: investmentBoardVM.investableAssets,
			filterDidTap: filterDidTap
		)
		dataSource = investmentDataSource
	}

	private func setupBinding() {
		investmentBoardVM.$investableAssets.sink { filteredAssets in
			self.investmentDataSource.investableAssets = filteredAssets
			self.reloadData()
		}.store(in: &cancellables)
	}
}
