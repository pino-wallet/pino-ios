//
//  SuggestedAddressesCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/19/23.
//

import UIKit

class SuggestedAddressesCollectionView: UICollectionView {
	// MARK: - Public Properties

	public var suggestedAddressesVM: SuggestedAddressesViewModel

	// MARK: - Initializers

	init(suggestedAddressesVM: SuggestedAddressesViewModel) {
		self.suggestedAddressesVM = suggestedAddressesVM

		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)

		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.collectionView?.backgroundColor = .Pino.secondaryBackground
		flowLayout.collectionView?.layer.cornerRadius = 8
		flowLayout.minimumLineSpacing = 16

		configureCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		delegate = self
		dataSource = self

		register(
			SuggestedAddressHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SuggestedAddressHeaderView.viewReuseID
		)
		register(RecentAddressCell.self, forCellWithReuseIdentifier: RecentAddressCell.cellReuseID)
		register(UserAddressCell.self, forCellWithReuseIdentifier: UserAddressCell.cellReuseID)
	}
}

extension SuggestedAddressesCollectionView: UICollectionViewDelegate {}

extension SuggestedAddressesCollectionView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return suggestedAddressesVM.recentAddresses.count
		case 1:
			return suggestedAddressesVM.userWallets.count
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			let recentAddressCell = dequeueReusableCell(
				withReuseIdentifier: RecentAddressCell.cellReuseID,
				for: indexPath
			) as! RecentAddressCell
			recentAddressCell
				.recentAddressVM = RecentAddressViewModel(
					recentAddressModel: suggestedAddressesVM.recentAddresses[indexPath.item]
				)
			return recentAddressCell
		case 1:
			let walletCell = dequeueReusableCell(
				withReuseIdentifier: UserAddressCell.cellReuseID,
				for: indexPath
			) as! UserAddressCell
			walletCell.walletVM = suggestedAddressesVM.userWallets[indexPath.row]
			return walletCell
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch indexPath.section {
		case 0:
			let headerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: SuggestedAddressHeaderView.viewReuseID,
				for: indexPath
			) as! SuggestedAddressHeaderView
			headerView.title = suggestedAddressesVM.recentAddressTitle
			return headerView
		case 1:
			let headerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: SuggestedAddressHeaderView.viewReuseID,
				for: indexPath
			) as! SuggestedAddressHeaderView
			headerView.title = suggestedAddressesVM.myAddressTitle
			return headerView
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}

extension SuggestedAddressesCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 44)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		switch section {
		case 0:
			return CGSize(width: collectionView.frame.width, height: 54)
		case 1:
			return CGSize(width: collectionView.frame.width, height: 62)
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}
