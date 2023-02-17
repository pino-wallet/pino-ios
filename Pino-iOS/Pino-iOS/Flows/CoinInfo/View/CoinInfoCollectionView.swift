//
//  CoinInfoCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import UIKit

class CoinInfoCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var cacncellabel = Set<AnyCancellable>()
	private let historyRefreshContorl = UIRefreshControl()
	private let refreshErrorTostView = PinoToastView(message: nil, style: .secondary, padding: 16)

	// MARK: - Internal Properties

	internal var coinInfoVM: CoinInfoViewModel!

	// MARK: - Initializers

	init(coinInfoVM: CoinInfoViewModel) {
		self.coinInfoVM = coinInfoVM
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)
		configCollectionView()
		setupView()
		setUpStyle()
		setupBinding()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func configCollectionView() {
		register(
			CoinInfoHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: CoinInfoHeaderView.headerReuseID
		)
		register(
			CoinHistoryCell.self,
			forCellWithReuseIdentifier: CoinHistoryCell.cellID
		)
		dataSource = self
		delegate = self
	}

	private func setupView() {
		setupRefreshControl()
	}

	private func setUpStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}

	private func setupBinding() {
		coinInfoVM.$coinHistoryList.sink { [weak self] _ in
			self?.reloadData()
		}.store(in: &cacncellabel)
	}

	private func setupRefreshControl() {
		indicatorStyle = .white
		historyRefreshContorl.tintColor = .Pino.green2
		historyRefreshContorl.addAction(UIAction(handler: { _ in
			self.refreshData()
		}), for: .valueChanged)
		refreshControl = historyRefreshContorl
	}

	private func refreshData() {
		coinInfoVM.refreshCoinInfoData { error in
			self.refreshControl?.endRefreshing()
			if let error {
				switch error {
				case .requestFaild:
					self.refreshErrorTostView.message = self.coinInfoVM.requestFailedErrorToastMessage
				case .networkingConnection:
					self.refreshErrorTostView.message = self.coinInfoVM.connectionErrorToastMessage
				}
				self.refreshErrorTostView.showToast()
			}
		}
	}
}

// MARK: - CollectionView Flow Layout

extension CoinInfoCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 72)
	}
}

// MARK: - CollectionView DataSource

extension CoinInfoCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		coinInfoVM.coinHistoryList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let coinInfoHeaderView = dequeueReusableSupplementaryView(
			ofKind: kind,
			withReuseIdentifier: CoinInfoHeaderView.headerReuseID,
			for: indexPath
		) as! CoinInfoHeaderView
		coinInfoHeaderView.coinInfoVM = coinInfoVM
		return coinInfoHeaderView
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		let indexPath = IndexPath(row: 0, section: section)
		let headerView = self.collectionView(
			collectionView,
			viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
			at: indexPath
		)
		return headerView.systemLayoutSizeFitting(
			CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let coinHistoryCell = dequeueReusableCell(
			withReuseIdentifier: CoinHistoryCell.cellID,
			for: indexPath
		) as! CoinHistoryCell
		coinHistoryCell.coinHistoryVM = coinInfoVM.coinHistoryList[indexPath.row]
		return coinHistoryCell
	}
}
