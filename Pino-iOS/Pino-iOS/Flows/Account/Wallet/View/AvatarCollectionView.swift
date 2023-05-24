//
//  AvatarCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/15/23.
//

import UIKit

class AvatarCollectionView: UICollectionView {
	// MARK: Private Properties

	private var avatarVM: AvatarViewModel
	private var avatarSelected: (String) -> Void

	// MARK: Initializers

	init(
		avatarVM: AvatarViewModel,
		avatarSelected: @escaping (String) -> Void
	) {
		self.avatarVM = avatarVM
		self.avatarSelected = avatarSelected
		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			minimumLineSpacing: 26,
			minimumItemSpacing: 26,
			sectionInset: UIEdgeInsets(top: 44, left: 16, bottom: 24, right: 16)
		)
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
			AvatarCell.self,
			forCellWithReuseIdentifier: AvatarCell.cellReuseID
		)

		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.background
		showsVerticalScrollIndicator = false
	}
}

// MARK: Collection View Flow Layout

extension AvatarCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 70, height: 70)
	}
}

// MARK: - CollectionView Delegate

extension AvatarCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		avatarVM.selectedAvatar = avatarVM.avatarsList[indexPath.row].rawValue
		avatarSelected(avatarVM.avatarsList[indexPath.row].rawValue)
		reloadData()
	}
}

// MARK: - CollectionView DataSource

extension AvatarCollectionView: UICollectionViewDataSource {
	internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		avatarVM.avatarsList.count
	}

	internal func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let avatarCell = dequeueReusableCell(
			withReuseIdentifier: AvatarCell.cellReuseID,
			for: indexPath
		) as! AvatarCell
		avatarCell.avatarName = avatarVM.avatarsList[indexPath.item].rawValue
		if avatarVM.avatarsList[indexPath.item].rawValue == avatarVM.selectedAvatar {
			avatarCell.style = .selected
		} else {
			avatarCell.style = .regular
		}
		return avatarCell
	}
}
