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

	// MARK: - Private Properties

	private let assetsRefreshControl = UIRefreshControl()
	private let refreshErrorToastView = PinoToastView(message: nil, style: .secondary)

	// MARK: - Public Properties

	public var manageAssetButtonTapped: () -> Void
	public var assetTapped: (AssetViewModel) -> Void
	internal var portfolioPerformanceTapped: () -> Void

	// MARK: - Internal Properties

	internal var homeVM: HomepageViewModel!
	internal var cancellables = Set<AnyCancellable>()

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
		setupBindings()
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
			WalletBalanceHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: WalletBalanceHeaderView.headerReuseID
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

	private func setupBindings() {
		homeVM.$assetsList.sink { [weak self] _ in
			self?.reloadData()

		}.store(in: &cancellables)

		homeVM.$positionAssetsList.sink { [weak self] _ in
			self?.reloadData()
		}.store(in: &cancellables)
	}

	private func setupRefreshControl() {
		indicatorStyle = .white
		assetsRefreshControl.tintColor = .Pino.green2
		assetsRefreshControl.addAction(UIAction(handler: { _ in
			self.refreshHomeData()
		}), for: .valueChanged)
		refreshControl = assetsRefreshControl
	}

	private func refreshHomeData() {
		homeVM.refreshHomeData { error in
			self.refreshControl?.endRefreshing()
			if let error {
				switch error {
				case .requestFailed:
					self.refreshErrorToastView.message = self.homeVM.requestFailedErrorToastMessage
				case .networkConnection:
					self.refreshErrorToastView.message = self.homeVM.connectionErrorToastMessage
				}
				self.refreshErrorToastView.showToast()
			}
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
			assetTapped(homeVM.assetsList[indexPath.item])
		case .position:
			assetTapped(homeVM.positionAssetsList[indexPath.item])
		default: break
		}
	}
}
