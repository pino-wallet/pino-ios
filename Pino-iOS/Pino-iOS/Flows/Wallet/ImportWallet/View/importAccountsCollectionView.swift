//
//  importAccountsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var accountsVM: ImportAccountsViewModel

	// MARK: - Initializers

	init(accountsVM: ImportAccountsViewModel) {
		self.accountsVM = accountsVM
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func configCollectionView() {
		register(
			ImportAccountCell.self,
			forCellWithReuseIdentifier: ImportAccountCell.cellReuseID
		)
		register(
			ImportAccountsHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ImportAccountsHeaderView.viewReuseID
		)
		register(
			ImportAccountsHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: ImportAccountsHeaderView.viewReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.secondaryBackground
		showsVerticalScrollIndicator = false
	}
}

// MARK: - Collection View Flow Layout

extension ImportAccountsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 72)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 56)
	}
}

// MARK: - CollectionView Delegate

extension ImportAccountsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: - CollectionView DataSource

extension ImportAccountsCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		accountsVM.accounts.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let accountCell = dequeueReusableCell(
			withReuseIdentifier: ImportAccountCell.cellReuseID,
			for: indexPath
		) as! ImportAccountCell
		accountCell.accountVM = accountsVM.accounts[indexPath.item]
		if accountsVM.accounts[indexPath.item].isSelected {
			accountCell.style = .selected
		} else {
			accountCell.style = .regular
		}
		return accountCell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: ImportAccountsHeaderView.viewReuseID,
				for: indexPath
			) as! ImportAccountsHeaderView
			headerView.pageInfo = (title: accountsVM.pageTitle, description: accountsVM.pageDescription)
			return headerView
		case UICollectionView.elementKindSectionFooter:
			let footerView = dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionFooter,
				withReuseIdentifier: ImportAccountsHeaderView.viewReuseID,
				for: indexPath
			) as! ImportAccountsHeaderView

			return footerView
		default:
			fatalError("cant dequeue reusable view")
		}
	}
}
