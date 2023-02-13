//
//  WalletsCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import UIKit

class WalletsCollectionView: UICollectionView {
	// MARK: Private Properties

	private var walletsVM: WalletsViewModel

	public var walletSelected: (WalletInfoViewModel) -> Void

	// MARK: Initializers

	init(walletsVM: WalletsViewModel, walletSelected: @escaping (WalletInfoViewModel) -> Void) {
		self.walletsVM = walletsVM
		self.walletSelected = walletSelected
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
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
		backgroundColor = .Pino.clear
		showsVerticalScrollIndicator = false
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
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: - CollectionView DataSource

extension WalletsCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		walletsVM.walletsList.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let walletCell = dequeueReusableCell(
			withReuseIdentifier: WalletCell.cellReuseID,
			for: indexPath
		) as! WalletCell
		walletCell.walletVM = walletsVM.walletsList[indexPath.item]
		return walletCell
	}
}
