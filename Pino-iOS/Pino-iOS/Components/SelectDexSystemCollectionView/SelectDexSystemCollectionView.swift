//
//  SwapProtocolCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class SelectDexSystemCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let selectDexSystemVM: SelectDexSystemVMProtocol
	private let dexProtocolDidSelect: (DexSystemModel) -> Void

	// MARK: - Initializers

	init(selectDexProtocolVM: SelectDexSystemVMProtocol, dexProtocolDidSelect: @escaping (DexSystemModel) -> Void) {
		self.selectDexSystemVM = selectDexProtocolVM
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

		register(DexSystemCell.self, forCellWithReuseIdentifier: DexSystemCell.cellReuseID)
	}
}

extension SelectDexSystemCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		dexProtocolDidSelect(selectDexSystemVM.dexSystemList[indexPath.item])
	}
}

extension SelectDexSystemCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		selectDexSystemVM.dexSystemList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: DexSystemCell.cellReuseID,
			for: indexPath
		) as! DexSystemCell
		cell.dexSystemVM = SelectDexCellViewModel(dexModel: selectDexSystemVM.dexSystemList[indexPath.item])
		return cell
	}
}

extension SelectDexSystemCollectionView: UICollectionViewDelegateFlowLayout {
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
