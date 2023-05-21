//
//  WalletsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import UIKit

class AccountsCollectionView: UICollectionView {
	// MARK: Private Properties

	private var accountsVM: AccountsViewModel
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public var editAccountTapped: (AccountInfoViewModel) -> Void

	// MARK: Initializers

	init(
		accountsVM: AccountsViewModel,
		editAccountTapped: @escaping (AccountInfoViewModel) -> Void
	) {
		self.accountsVM = accountsVM
		self.editAccountTapped = editAccountTapped
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
		setupBindings()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(
			AccountCell.self,
			forCellWithReuseIdentifier: AccountCell.cellReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}

	private func setupBindings() {
		accountsVM.$accountsList.sink { [weak self] _ in
			self?.reloadData()
		}.store(in: &cancellables)
	}
}

// MARK: Collection View Flow Layout

extension AccountsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 68)
	}
}

// MARK: - CollectionView Delegate

extension AccountsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		accountsVM.updateSelectedAccount(with: accountsVM.accountsList[indexPath.item])
	}
}

// MARK: - CollectionView DataSource

extension AccountsCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		accountsVM.accountsList.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let accountCell = dequeueReusableCell(
			withReuseIdentifier: AccountCell.cellReuseID,
			for: indexPath
		) as! AccountCell
        accountCell.accountVM = accountsVM.accountsList[indexPath.item]
		if accountsVM.accountsList[indexPath.item].isSelected {
            accountCell.style = .selected
		} else {
            accountCell.style = .regular
		}
        accountCell.editButtonTapped = {
			self.editAccountTapped(self.accountsVM.accountsList[indexPath.item])
		}
		return accountCell
	}
}
