//
//  importAccountsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import UIKit

class ImportAccountsCollectionView: UICollectionView {
	// MARK: - Private Properties

	private var accounts: [ActiveAccountViewModel]

	// MARK: - Initializers

	init(accounts: [ActiveAccountViewModel]) {
		self.accounts = accounts
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
		CGSize(width: collectionView.frame.width, height: 68)
	}
}

// MARK: - CollectionView Delegate

extension ImportAccountsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
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
}
