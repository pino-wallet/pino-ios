//
//  AssetsBoardCollectionViewDelegate.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/19/23.
//

import UIKit

class AssetsBoardCollectionView: UICollectionView {
	// MARK: - Public Properties

	public var assets: [AssetsBoardProtocol]
	public var isLoading = false

	// MARK: - Private Properties

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
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
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
            guard !userAssets.isEmpty else {
                return
            }
			assetDidSelect(userAssets[indexPath.item])
		case 1:
            guard !assets.isEmpty else {
                return
            }
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
		CGSize(width: collectionView.frame.width, height: 92)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		switch section {
		case 0:
			if userAssets.isEmpty {
				return .zero
			} else {
				return CGSize(width: collectionView.frame.width, height: 54)
			}
		case 1:
			guard !isLoading else {
				return CGSize(width: collectionView.frame.width, height: 54)
			}
			if assets.isEmpty {
				return .zero
			} else {
				return CGSize(width: collectionView.frame.width, height: 54)
			}
		default:
			fatalError("Invalid section index in collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
	}
}
