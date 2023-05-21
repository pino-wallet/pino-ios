//
//  EditAccountCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 4/25/23.
//

import Combine
import UIKit

class EditAccountCollectionView: UICollectionView {
	// MARK: - Closures

	public let newAvatarTappedClosure: () -> Void
	public let openRevealPrivateKeyClosure: () -> Void
	public let openEditAccountNameClosure: () -> Void

	// MARK: - Public Properties

	public let editAccountVM: EditAccountViewModel

	// MARK: - Initializers

	init(
		editAccountVM: EditAccountViewModel,
		newAvatarTappedClosure: @escaping () -> Void,
		openRevealPrivateKeyClosure: @escaping () -> Void,
		openEditAccountNameClosure: @escaping () -> Void
	) {
		self.editAccountVM = editAccountVM
		self.newAvatarTappedClosure = newAvatarTappedClosure
		self.openRevealPrivateKeyClosure = openRevealPrivateKeyClosure
		self.openEditAccountNameClosure = openEditAccountNameClosure

		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
		)

		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.collectionView?.backgroundColor = .Pino.background
		configureCollectionView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		register(
			EditAccountHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: EditAccountHeaderView.headerReuseID
		)
		register(EditAccountCell.self, forCellWithReuseIdentifier: EditAccountCell.cellReuseID)

		delegate = self
		dataSource = self
	}

	private func setupBindings() {}
}

extension EditAccountCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch editAccountVM.editAccountOptions[indexPath.item].type {
		case .name:
			openEditAccountNameClosure()
		case .private_key:
			openRevealPrivateKeyClosure()
		}
	}
}

extension EditAccountCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		editAccountVM.editAccountOptions.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: EditAccountCell.cellReuseID,
			for: indexPath
		) as! EditAccountCell
		let editAccountOption = editAccountVM.editAccountOptions[indexPath.item]
		cell.editAccountOptionVM = EditAccountOptionViewModel(editAccountOption: editAccountOption)
		cell.setCellStyle(currentItem: indexPath.item, itemsCount: editAccountVM.editAccountOptions.count)
		if editAccountOption.type == .name {
			cell.cellDescribtionText = "\(editAccountVM.selectedAccount.name)"
		}
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		let headerView = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: EditAccountHeaderView.headerReuseID,
			for: indexPath
		) as! EditAccountHeaderView
		headerView.editAccountVM = editAccountVM
		headerView.selectedAccountVM = editAccountVM.selectedAccount
		headerView.newAvatarTapped = newAvatarTappedClosure
		return headerView
	}
}

extension EditAccountCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 176)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 0)
	}
}
