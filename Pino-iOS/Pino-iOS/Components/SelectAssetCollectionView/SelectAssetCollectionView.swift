//
//  SelectAssetCollectionView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/10/23.
//

import UIKit

class SelectAssetCollectionView: UICollectionView {
	// MARK: - Public Properties

	public var selectAssetVM: SelectAssetVMProtocol

	// MARK: - Initializers

	init(selectAssetVM: SelectAssetVMProtocol) {
		self.selectAssetVM = selectAssetVM
		let collecttionviewFlowLayout = UICollectionViewFlowLayout(
			scrollDirection: .vertical,
			sectionInset: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
		)

		super.init(frame: .zero, collectionViewLayout: collecttionviewFlowLayout)
		collecttionviewFlowLayout.collectionView?.backgroundColor = .Pino.background

		configureCollectionview()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Closures

	public var didSelectAsset: (_ selectedAsset: AssetProtocol) -> Void = { _ in }

	// MARK: - Private Methods

	private func configureCollectionview() {
		delegate = self
		dataSource = self

		register(SelectAssetCell.self, forCellWithReuseIdentifier: SelectAssetCell.cellReuseID)
	}
}

extension SelectAssetCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		didSelectAsset(selectAssetVM.filteredAndSearchedAssetList[indexPath.item]!)
	}
}

extension SelectAssetCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		selectAssetVM.filteredAndSearchedAssetList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: SelectAssetCell.cellReuseID,
			for: indexPath
		) as! SelectAssetCell
		cell
			.selectAssetCellVM = SelectAssetCellViewModel(
				assetModel: selectAssetVM
					.filteredAndSearchedAssetList[indexPath.item]!
			)
		return cell
	}
}

extension SelectAssetCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 32, height: 64)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		8
	}
}
