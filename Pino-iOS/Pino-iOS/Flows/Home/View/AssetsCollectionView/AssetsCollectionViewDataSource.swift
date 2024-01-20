//
//  AssetsCollectionViewDataSource.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/24/22.
//

import UIKit

extension AssetsCollectionView: UICollectionViewDataSource {
	// MARK: - CollectionView DataSource Methods

	internal func numberOfSections(in collectionView: UICollectionView) -> Int {
		if let selectedPositions, !selectedPositions.isEmpty {
			return 2
		} else {
			return 1
		}
	}

	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let homeSection = HomeSection(rawValue: section)
		if let selectedAssets {
			switch homeSection {
			case .asset:
				return selectedAssets.count
			case .position:
				return selectedPositions?.count ?? .zero
			case .none:
				return .zero
			}
		} else {
			return 6
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		assetCollectionViewCell(indexPath: indexPath)
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionFooter:
			return homepageFooterView(kind: kind, indexPath: indexPath)!
		case UICollectionView.elementKindSectionHeader:
			return homepageHeaderView(kind: kind, indexPath: indexPath)!
		default:
			fatalError("Unexpected element kind")
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		let homeSection = HomeSection(rawValue: section)
		switch homeSection {
		case .asset:
			return CGSize(width: collectionView.frame.width, height: 212)
		case .position:
			return CGSize(width: collectionView.frame.width, height: 46)
		case .none:
			return .zero
		}
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		let homeSection = HomeSection(rawValue: section)
		switch homeSection {
		case .asset:
			if selectedAssets == nil {
				return .zero
			} else if let selectedPositions, !selectedPositions.isEmpty {
				return .zero
			} else if let selectedAssets, selectedAssets.isEmpty {
				// Calculate homepage height without calculating balance header
				let assetsSectionHeight = collectionView.frame.height - 400
				return CGSize(width: collectionView.frame.width, height: assetsSectionHeight)
			} else {
				return CGSize(width: collectionView.frame.width, height: 120)
			}
		case .position:
			return CGSize(width: collectionView.frame.width, height: 120)
		case .none:
			return .zero
		}
	}

	// MARK: - Private Methods

	private func homepageHeaderView(kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
		let homeSection = HomeSection(rawValue: indexPath.section)
		switch homeSection {
		case .asset:
			// Wallet balance header
			let walletBalanceHeaderView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: AccountBalanceHeaderView.headerReuseID,
				for: indexPath
			) as! AccountBalanceHeaderView
			walletBalanceHeaderView.homeVM = homeVM
			walletBalanceHeaderView.sendButtonTappedClosure = sendButtonTappedClosure
			walletBalanceHeaderView.receiveButtonTappedClosure = receiveButtonTappedClosure
			walletBalanceHeaderView.portfolioPerformanceTapped = portfolioPerformanceTapped
			if selectedAssets == nil {
				walletBalanceHeaderView.showSkeletonView()
			} else {
				walletBalanceHeaderView.hideSkeletonView()
			}
			return walletBalanceHeaderView

		case .position:
			// Positon section header
			let positionHeaderView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: PositionHeaderView.headerReuseID,
				for: indexPath
			) as! PositionHeaderView
			positionHeaderView.title = "Position"
			return positionHeaderView

		case .none:
			return nil
		}
	}

	private func homepageFooterView(kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
		if let selectedAssets, selectedAssets.isEmpty, let selectedPositions, selectedPositions.isEmpty {
			let emptyStateView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: HomepageEmptyStateView.footerReuseID,
				for: indexPath
			) as! HomepageEmptyStateView
			emptyStateView.isEmptyState = true
			emptyStateView.manageAssetButton.addAction(UIAction(handler: { _ in
				self.manageAssetButtonTapped()
			}), for: .touchUpInside)
			return emptyStateView
		} else {
			let manageAssetsFooterView = dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: ManageAssetsFooterView.footerReuseID,
				for: indexPath
			) as! ManageAssetsFooterView
			manageAssetsFooterView.title = "Manage assets"
			manageAssetsFooterView.manageAssetButton.addAction(UIAction(handler: { _ in
				self.manageAssetButtonTapped()
			}), for: .touchUpInside)
			return manageAssetsFooterView
		}
	}

	private func assetCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell {
		let assetCell = dequeueReusableCell(
			withReuseIdentifier: AssetsCollectionViewCell.cellReuseID,
			for: indexPath
		) as! AssetsCollectionViewCell
		if let selectedAssets {
			assetCell.hideSkeletonView()
			let homeSection = HomeSection(rawValue: indexPath.section)
			switch homeSection {
			case .asset:
				assetCell.assetVM = selectedAssets[indexPath.row]
			case .position:
				assetCell.assetVM = selectedPositions?[indexPath.row]
			case .none: break
			}
		} else {
			assetCell.assetVM = nil
			assetCell.showSkeletonView()
		}
		return assetCell
	}

	enum HomeSection: Int, CaseIterable {
		case asset
		case position
	}
}
