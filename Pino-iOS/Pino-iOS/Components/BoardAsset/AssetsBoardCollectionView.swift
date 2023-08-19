//
//  AssetsBoardCollectionViewDelegate.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class AssetsBoardCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let assets: [AssetsBoardProtocol]
	private let userAssets: [AssetsBoardProtocol]
	private let assetDidSelect: (AssetsBoardProtocol) -> Void

	// MARK: - Initializers

	init(
		assets: [AssetsBoardProtocol],
		userAssets: [AssetsBoardProtocol],
		assetDidSelect: @escaping (AssetsBoardProtocol) -> Void
	) {
		self.assets = assets
		self.userAssets = userAssets
		self.assetDidSelect = assetDidSelect
		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
		)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configureCollectionView()
		setupStyle()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		delegate = self

		register(
			AssetsBoardHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: AssetsBoardHeaderView.viewReuseID
		)
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
	}
}

extension AssetsBoardCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			assetDidSelect(userAssets[indexPath.item])
		case 1:
			return assetDidSelect(assets[indexPath.item])
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}

extension AssetsBoardCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 64)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 54)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
	}
}
