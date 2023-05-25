//
//  CreateImportWalletCollectionView.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/16/23.
//

import UIKit

class AddNewAccountCollectionView: UICollectionView {
	// MARK: - Typealiases

	public typealias openAddNewAccountPageClosureType = (AddNewAccountOptionModel) -> Void

	// MARK: - Public Properties

	public var openAddNewAccountPageClosure: openAddNewAccountPageClosureType

	public let addNewAccountVM: AddNewAccountViewModel

	// MARK: - Initializers

	init(
		addNewAccountVM: AddNewAccountViewModel,
		openAddNewAccountPageClosure: @escaping openAddNewAccountPageClosureType
	) {
		self.addNewAccountVM = addNewAccountVM
		self.openAddNewAccountPageClosure = openAddNewAccountPageClosure
		let flowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
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
			AddNewAccountCollectionViewCell.self,
			forCellWithReuseIdentifier: AddNewAccountCollectionViewCell.cellReuseID
		)

		delegate = self
		dataSource = self
	}
}

extension AddNewAccountCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedAddNewAccountOption = addNewAccountVM.AddNewAccountOptions[indexPath.item]
		openAddNewAccountPageClosure(selectedAddNewAccountOption!)
	}
}

// MARK: Collection View Flow Layout

extension AddNewAccountCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 76)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		8
	}
}

extension AddNewAccountCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		addNewAccountVM.AddNewAccountOptions.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let addNewAccountCell = dequeueReusableCell(
			withReuseIdentifier: AddNewAccountCollectionViewCell.cellReuseID,
			for: indexPath
		) as! AddNewAccountCollectionViewCell
		addNewAccountCell
			.addNewAccountOptionVM = AddNewAccountOptionViewModel(
				addNewAccountOption: addNewAccountVM
					.AddNewAccountOptions[indexPath.item]!
			)

		return addNewAccountCell
	}
}
