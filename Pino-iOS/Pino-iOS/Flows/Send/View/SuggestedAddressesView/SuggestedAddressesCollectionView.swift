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

	// MARK: - Private Properties

	private var recentAddressDidSelect: (String) -> Void
	private var userWalletDidSelect: (AccountInfoViewModel) -> Void

	// MARK: - Initializers

	init(
		suggestedAddressesVM: SuggestedAddressesViewModel,
		recentAddressDidSelect: @escaping (String) -> Void,
		userWalletDidSelect: @escaping (AccountInfoViewModel) -> Void
	) {
		self.suggestedAddressesVM = suggestedAddressesVM
		self.recentAddressDidSelect = recentAddressDidSelect
		self.userWalletDidSelect = userWalletDidSelect

		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical, minimumLineSpacing: 16)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

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

extension SuggestedAddressesCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			recentAddressDidSelect(suggestedAddressesVM.recentAddresses[indexPath.item].address)
		case 1:
			return userWalletDidSelect(suggestedAddressesVM.userWallets[indexPath.item])
		default:
			fatalError("Invalid section index in notificaition collection view")
		}
	}
}

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
		let headerSize = CGSize(width: collectionView.frame.width, height: 54)
		if section == 0 {
			if suggestedAddressesVM.recentAddresses.isEmpty {
				return CGSize.zero
			} else {
				return headerSize
			}
		} else if section == 1 {
			if suggestedAddressesVM.userWallets.isEmpty {
				return CGSize.zero
			} else {
				return headerSize
			}
		} else {
			return CGSize.zero
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		if section == 0 {
			if suggestedAddressesVM.recentAddresses.isEmpty {
				return .zero
			} else {
				return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
			}
		} else {
			if suggestedAddressesVM.userWallets.isEmpty {
				return .zero
			} else {
				return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
			}
		}
	}
}
