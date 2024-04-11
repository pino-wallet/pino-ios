//
//  AssetsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/20/22.
//

import Combine
import UIKit

class AssetsCollectionView: UICollectionView {
	// MARK: - Closure

	public var receiveButtonTappedClosure: () -> Void
	public var sendButtonTappedClosure: () -> Void
	public var selectedAssets: [AssetViewModel]?
	public var selectedPositions: [AssetViewModel]?

	// MARK: - Private Properties

	private let assetsRefreshControl = UIRefreshControl()

	// MARK: - Public Properties

	public var manageAssetButtonTapped: () -> Void
	public var assetTapped: (AssetViewModel) -> Void

	// MARK: - Internal Properties

	internal var homeVM: HomepageViewModel!
	internal var cancellables = Set<AnyCancellable>()
	internal var portfolioPerformanceTapped: () -> Void

	// MARK: Initializers

	init(
		homeVM: HomepageViewModel,
		manageAssetButtonTapped: @escaping () -> Void,
		assetTapped: @escaping (AssetViewModel) -> Void,
		receiveButtonTappedClosure: @escaping () -> Void,
		sendButtonTappedClosure: @escaping () -> Void,
		portfolioPerformanceTapped: @escaping () -> Void
	) {
		self.homeVM = homeVM
		self.manageAssetButtonTapped = manageAssetButtonTapped
		self.assetTapped = assetTapped
		self.receiveButtonTappedClosure = receiveButtonTappedClosure
		self.sendButtonTappedClosure = sendButtonTappedClosure
		self.portfolioPerformanceTapped = portfolioPerformanceTapped
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupView()
		setupStyle()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			AssetsCollectionViewCell.self,
			forCellWithReuseIdentifier: AssetsCollectionViewCell.cellReuseID
		)
		register(
			AccountBalanceHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: AccountBalanceHeaderView.headerReuseID
		)
		register(
			PositionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: PositionHeaderView.headerReuseID
		)
		register(
			ManageAssetsFooterView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: ManageAssetsFooterView.footerReuseID
		)

		register(
			HomepageEmptyStateView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: HomepageEmptyStateView.footerReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupView() {
		setupRefreshControl()
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
		showsVerticalScrollIndicator = false
	}

	private func setupRefreshControl() {
		indicatorStyle = .white
		assetsRefreshControl.tintColor = .Pino.green2
		assetsRefreshControl.addAction(UIAction(handler: { _ in
			self.getHomeData()
		}), for: .valueChanged)
		refreshControl = assetsRefreshControl
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}

	// MARK: - Public Methods

	public func getHomeData() {
		GlobalVariables.shared.fetchSharedInfo().done { _ in
			self.refreshControl?.endRefreshing()
		}.catch { error in
			self.refreshControl?.endRefreshing()
			self.showErrorToast(error)
		}
	}
}

// MARK: Collection View Flow Layout

extension AssetsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 72)
	}
}

extension AssetsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let homeSection = HomeSection(rawValue: indexPath.section)
		switch homeSection {
		case .asset:
			if let selectedAssets {
				assetTapped(selectedAssets[indexPath.item])
			}
		case .position:
			if let selectedPositions {
				assetTapped(selectedPositions[indexPath.item])
			}
		default: break
		}
	}
}
