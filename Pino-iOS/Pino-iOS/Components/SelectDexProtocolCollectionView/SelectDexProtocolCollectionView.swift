//
//  SwapProtocolCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class SelectDexProtocolCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let selectDexProtocolVM: SelectDexProtocolVMProtocol
	private let dexProtocolDidSelect: (dexProtocolModel) -> Void

	// MARK: - Initializers

	init(selectDexProtocolVM: SelectDexProtocolVMProtocol, dexProtocolDidSelect: @escaping (dexProtocolModel) -> Void) {
		self.selectDexProtocolVM = selectDexProtocolVM
		self.dexProtocolDidSelect = dexProtocolDidSelect
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

	// MARK: - Private Methods

	private func configureCollectionview() {
		delegate = self
		dataSource = self

		register(DexProtocolCell.self, forCellWithReuseIdentifier: DexProtocolCell.cellReuseID)
	}
}

extension SelectDexProtocolCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		dexProtocolDidSelect(selectDexProtocolVM.dexProtocolsList[indexPath.item])
	}
}

extension SelectDexProtocolCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		selectDexProtocolVM.dexProtocolsList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: DexProtocolCell.cellReuseID,
			for: indexPath
		) as! DexProtocolCell
		cell.dexProtocolVM = SelectDexCellViewModel(dexModel: selectDexProtocolVM.dexProtocolsList[indexPath.item])
		return cell
	}
}

extension SelectDexProtocolCollectionView: UICollectionViewDelegateFlowLayout {
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
