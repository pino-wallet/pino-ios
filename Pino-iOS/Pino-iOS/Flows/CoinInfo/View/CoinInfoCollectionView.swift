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

	private var cancellable = Set<AnyCancellable>()
	private let historyRefreshContorl = UIRefreshControl()
	private let refreshErrorTostView = PinoToastView(message: nil, style: .secondary, padding: 16)
	private var coinInfoVM: CoinInfoViewModel!
	private var coinPortfolioInfo: CoinPortfolioViewModel!

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
		register(
			CoinInfoFooterview.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: CoinInfoFooterview.footerReuseID
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
		coinInfoVM.$coinPortfolio.sink { [weak self] coinPortfolio in
			self?.coinPortfolioInfo = coinPortfolio
			self?.reloadData()
		}.store(in: &cancellable)
		coinInfoVM.$coinHistoryList.sink { [weak self] _ in
			self?.reloadData()
		}.store(in: &cancellable)
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
				case .unreachable:
					self.refreshErrorTostView.message = self.coinInfoVM.connectionErrorToastMessage
				default:
					self.refreshErrorTostView.message = self.coinInfoVM.requestFailedErrorToastMessage
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
		switch coinPortfolioInfo.type {
		case .verified:
			return coinInfoVM.coinHistoryList.count
		case .unVerified:
			return 0
		case .position:
			return 0
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let coinInfoHeaderView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: CoinInfoHeaderView.headerReuseID,
				for: indexPath
			) as! CoinInfoHeaderView
			coinInfoHeaderView.coinInfoVM = coinInfoVM
			return coinInfoHeaderView
		case UICollectionView.elementKindSectionFooter:
			let coinInfoFooterView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionFooter,
				withReuseIdentifier: CoinInfoFooterview.footerReuseID,
				for: indexPath
			) as! CoinInfoFooterview
			coinInfoFooterView.coinInfoVM = coinInfoVM

			return coinInfoFooterView
		default:
			fatalError("Unknown kind of coin info reusable view")
		}
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
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		switch coinPortfolioInfo.type {
		case .verified:
			return CGSize(width: 0, height: 0)
		case .unVerified:
			return CGSize(width: collectionView.frame.width, height: 200)
		case .position:
			return CGSize(width: collectionView.frame.width, height: 200)
		}
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
