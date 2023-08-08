//
//  ProviderCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class SwapProvidersCollectionView: UICollectionView {
	// MARK: - Private Properties

	private let providerDidSelect: (SwapProviderViewModel) -> Void

	// MARK: - Public Properties

	public var swapProviders = [SwapProviderViewModel]()
	public var bestProvider: SwapProviderViewModel?

	// MARK: - Initializers

	init(providerDidSelect: @escaping (SwapProviderViewModel) -> Void) {
		self.providerDidSelect = providerDidSelect
		let collecttionviewFlowLayout = UICollectionViewFlowLayout(scrollDirection: .vertical)
		super.init(frame: .zero, collectionViewLayout: collecttionviewFlowLayout)

		configureCollectionview()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionview() {
		delegate = self
		dataSource = self

		register(SwapProviderCell.self, forCellWithReuseIdentifier: SwapProviderCell.cellReuseID)
	}
}

extension SwapProvidersCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		providerDidSelect(swapProviders[indexPath.item])
	}
}

extension SwapProvidersCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		swapProviders.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: SwapProviderCell.cellReuseID,
			for: indexPath
		) as! SwapProviderCell
		cell.swapProviderVM = swapProviders[indexPath.item]
		if let bestProvider, swapProviders[indexPath.item].provider == bestProvider.provider {
			cell.cellStyle = .bestRate
		} else {
			cell.cellStyle = .normal
		}
		return cell
	}
}

extension SwapProvidersCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 64)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		8
	}
}
