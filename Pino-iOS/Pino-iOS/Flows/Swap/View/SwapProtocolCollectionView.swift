//
//  SwapProtocolCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/5/23.
//

import UIKit

class SwapProtocolCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let swapProtocols: [SwapProtocol]
	private let protocolDidSelect: (SwapProtocol) -> Void

	// MARK: - Initializers

	init(swapProtocols: [SwapProtocol], protocolDidSelect: @escaping (SwapProtocol) -> Void) {
		self.swapProtocols = swapProtocols
		self.protocolDidSelect = protocolDidSelect
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

		register(SwapProtocolCell.self, forCellWithReuseIdentifier: SwapProtocolCell.cellReuseID)
	}
}

extension SwapProtocolCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		protocolDidSelect(swapProtocols[indexPath.item])
	}
}

extension SwapProtocolCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		swapProtocols.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: SwapProtocolCell.cellReuseID,
			for: indexPath
		) as! SwapProtocolCell
		cell.swapProtocol = swapProtocols[indexPath.item]
		return cell
	}
}

extension SwapProtocolCollectionView: UICollectionViewDelegateFlowLayout {
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
