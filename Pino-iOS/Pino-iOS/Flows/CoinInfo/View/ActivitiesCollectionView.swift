//
//  CoinInfoCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/17/23.
//

import Combine
import UIKit

class ActivitiesCollectionView: UICollectionView {
	// MARK: - TypeAliases

	typealias OpenActivityDetailsType = (_ activityDetails: ActivityCellViewModel) -> Void

	// MARK: - Public Properties

	@Published
	public var showLoading = true
	public var openActivityDetails: OpenActivityDetailsType

	// MARK: - Private Properties

	private var cancellables = Set<AnyCancellable>()
	private let historyRefreshContorl = UIRefreshControl()
	private var coinInfoVM: CoinInfoViewModel!
	private var separatedActivities: ActivityHelper.SeparatedActivitiesType! = []
	private var isRefreshing = false

	// MARK: - Initializers

	init(coinInfoVM: CoinInfoViewModel, openActivityDetails: @escaping OpenActivityDetailsType) {
		self.coinInfoVM = coinInfoVM
		self.openActivityDetails = openActivityDetails
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.minimumLineSpacing = 8
		flowLayout.sectionHeadersPinToVisibleBounds = true

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
			ActivityHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ActivityHeaderView.viewReuseID
		)
		register(
			ActivityCell.self,
			forCellWithReuseIdentifier: ActivityCell.cellID
		)
		register(
			CoinInfoFooterview.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: CoinInfoFooterview.footerReuseID
		)
		register(
			CoinInfoEmptyStateFooterView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: CoinInfoEmptyStateFooterView.emptyStateFooterID
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
		let activityHelper = ActivityHelper()
		coinInfoVM.$coinHistoryActivitiesCellVMList.sink { [weak self] activities in
			guard let userActivitiesOnToken = activities else {
				self?.showLoading = true
				return
			}
			self?.separatedActivities = activityHelper
				.separateActivitiesByTime(activities: userActivitiesOnToken)
			self?.separatedActivities.insert((title: "", activities: []), at: 0)
			guard let isRefreshingStatus = self?.isRefreshing else {
				return
			}
			if isRefreshingStatus {
				self?.refreshControl?.endRefreshing()
			}
			self?.showLoading = false
			self?.reloadData()
		}.store(in: &cancellables)
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
		isRefreshing = true
		coinInfoVM.refreshCoinInfoData().done {
			self.isRefreshing = false
			self.refreshControl?.endRefreshing()
		}.catch { error in
			self.isRefreshing = false
			self.refreshControl?.endRefreshing()
			guard let error = error as? APIError else { return }
			Toast.default(title: error.toastMessage, style: .error).show(haptic: .warning)
		}
	}
}

// MARK: - CollectionView Delegate

extension ActivitiesCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if !showLoading {
			openActivityDetails(separatedActivities[indexPath.section].activities[indexPath.item])
		}
	}
}

// MARK: - CollectionView Flow Layout

extension ActivitiesCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 64)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		if section == 0 && showLoading && coinInfoVM.coinPortfolio.type == .verified {
			return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
		}
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

// MARK: - CollectionView DataSource

extension ActivitiesCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if separatedActivities.isEmpty || coinInfoVM.coinPortfolio.type != .verified {
			return 1
		} else {
			return separatedActivities.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			if showLoading {
				return 5
			} else {
				if separatedActivities.indices.contains(section) {
					return separatedActivities[section].activities.count
				} else {
					return 0
				}
			}
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
			if indexPath.section == 0 {
				let coinInfoHeaderView = dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: CoinInfoHeaderView.headerReuseID,
					for: indexPath
				) as! CoinInfoHeaderView
				coinInfoHeaderView.coinInfoVM = coinInfoVM
				return coinInfoHeaderView
			} else {
				let activityHeaderView = dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: ActivityHeaderView.viewReuseID,
					for: indexPath
				) as! ActivityHeaderView
				if !showLoading {
					activityHeaderView.titleText = separatedActivities[indexPath.section].title
				}
				return activityHeaderView
			}
		case UICollectionView.elementKindSectionFooter:
			switch coinInfoVM.coinPortfolio.type {
			case .verified:
				let coinInfoFooterView = dequeueReusableSupplementaryView(
					ofKind: UICollectionView.elementKindSectionFooter,
					withReuseIdentifier: CoinInfoEmptyStateFooterView.emptyStateFooterID,
					for: indexPath
				) as! CoinInfoEmptyStateFooterView

				coinInfoFooterView.emptyFooterVM = CoinInfoEmptyStateFooterViewModel(
					titleText: coinInfoVM.emptyActivityTitleText,
					iconName: coinInfoVM.emptyActivityIconName, descriptionText: coinInfoVM.emptyActivityDescriptionText
				)
				return coinInfoFooterView
			case .unVerified:
				let coinInfoFooterView = dequeueReusableSupplementaryView(
					ofKind: UICollectionView.elementKindSectionFooter,
					withReuseIdentifier: CoinInfoFooterview.footerReuseID,
					for: indexPath
				) as! CoinInfoFooterview

				coinInfoFooterView.coinInfoVM = coinInfoVM

				return coinInfoFooterView
			case .position:
				let coinInfoFooterView = dequeueReusableSupplementaryView(
					ofKind: UICollectionView.elementKindSectionFooter,
					withReuseIdentifier: CoinInfoFooterview.footerReuseID,
					for: indexPath
				) as! CoinInfoFooterview

				coinInfoFooterView.coinInfoVM = coinInfoVM

				return coinInfoFooterView
			}

		default:
			fatalError("Unknown kind of coin info reusable view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		if section == 0 {
			return CGSize(width: collectionView.frame.width, height: 336)
		} else {
			if showLoading {
				return CGSize(width: 0, height: 0)
			} else {
				return CGSize(width: collectionView.frame.width, height: 46)
			}
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		switch coinInfoVM.coinPortfolio.type {
		case .verified:
			guard let userAcitivites = coinInfoVM.coinHistoryActivitiesCellVMList else {
				return CGSize(width: 0, height: 0)
			}
			if userAcitivites.isEmpty {
				return CGSize(width: collectionView.frame.width, height: 220)
			}
			return CGSize(width: 0, height: 0)
		case .unVerified:
			return CGSize(width: collectionView.frame.width, height: 44)
		case .position:
			return CGSize(width: collectionView.frame.width, height: 68)
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let coinHistoryCell = dequeueReusableCell(
			withReuseIdentifier: ActivityCell.cellID,
			for: indexPath
		) as! ActivityCell
		if showLoading {
			coinHistoryCell.activityCellVM = nil
			coinHistoryCell.showSkeletonView()
		} else {
			coinHistoryCell.activityCellVM = separatedActivities[indexPath.section].activities[indexPath.item]
			coinHistoryCell.hideSkeletonView()
		}
		return coinHistoryCell
	}
}
