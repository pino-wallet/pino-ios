//
//  importAccountsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let hapticManager = HapticManager()
	private var accountsVM: ImportAccountsViewModel
	private var findAccountsDidTap: () -> Void

	// MARK: - Public Properties

	public var accounts: [ActiveAccountViewModel]!

	// MARK: - Initializers

	init(accountsVM: ImportAccountsViewModel, findAccountsDidTap: @escaping () -> Void) {
		self.accountsVM = accountsVM
		self.findAccountsDidTap = findAccountsDidTap
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
			ImportAccountsFooterView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: ImportAccountsFooterView.footerReuseID
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
		if let firstAccount = accounts.first, firstAccount.isNewWallet {
			return CGSize(width: collectionView.frame.width, height: 80)
		} else {
			return CGSize(width: collectionView.frame.width, height: 56)
		}
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForFooterInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 64)
	}
}

// MARK: - CollectionView Delegate

extension ImportAccountsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		hapticManager.run(type: .selectionChanged)
		accountsVM.accounts[indexPath.item].toggleIsSelected()
	}
}

// MARK: - CollectionView DataSource

extension ImportAccountsCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		accounts.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let accountCell = dequeueReusableCell(
			withReuseIdentifier: ImportAccountCell.cellReuseID,
			for: indexPath
		) as! ImportAccountCell
		accountCell.accountVM = accounts[indexPath.item]
		if accounts[indexPath.item].isSelected {
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
				withReuseIdentifier: ImportAccountsFooterView.footerReuseID,
				for: indexPath
			) as! ImportAccountsFooterView
			if accountsVM.isMoreAccountExist {
				footerView.title = accountsVM.findMoreAccountTitle
				footerView.findAccountDidTap = {
					self.hapticManager.run(type: .selectionChanged)
					self.findAccountsDidTap()
				}
			} else {
				footerView.title = accountsVM.noMoreAccountTitle
				footerView.findAccountDidTap = nil
			}
			return footerView
		default:
			fatalError("cant dequeue reusable view")
		}
	}
}
