//
//  WalletsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import Combine
import UIKit

class WalletsCollectionView: UICollectionView {
	// MARK: Private Properties

	private var walletsVM: WalletsViewModel
	private var cancellables = Set<AnyCancellable>()

	// MARK: Public Properties

	public var editAccountTapped: (WalletInfoViewModel) -> Void

	// MARK: Initializers

	init(
		walletsVM: WalletsViewModel,
		editAccountTapped: @escaping (WalletInfoViewModel) -> Void
	) {
		self.walletsVM = walletsVM
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
			WalletCell.self,
			forCellWithReuseIdentifier: WalletCell.cellReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}

	private func setupBindings() {
		walletsVM.$accountsList.sink { [weak self] _ in
			self?.reloadData()
		}.store(in: &cancellables)
	}
}

// MARK: Collection View Flow Layout

extension WalletsCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 68)
	}
}

// MARK: - CollectionView Delegate

extension WalletsCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		walletsVM.updateSelectedWallet(with: walletsVM.accountsList[indexPath.item])
	}
}

// MARK: - CollectionView DataSource

extension WalletsCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		walletsVM.accountsList.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let walletCell = dequeueReusableCell(
			withReuseIdentifier: WalletCell.cellReuseID,
			for: indexPath
		) as! WalletCell
		walletCell.walletVM = walletsVM.accountsList[indexPath.item]
		if walletsVM.accountsList[indexPath.item].isSelected {
			walletCell.style = .selected
		} else {
			walletCell.style = .regular
		}
		walletCell.editButtonTapped = {
			self.editAccountTapped(self.walletsVM.accountsList[indexPath.item])
		}
		return walletCell
	}
}
