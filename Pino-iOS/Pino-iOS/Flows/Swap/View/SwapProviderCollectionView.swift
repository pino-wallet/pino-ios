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

	public var swapProviders: [SwapProviderViewModel]?
	public var bestProvider: SwapProviderViewModel?
	public var selectedProvider: SwapProviderViewModel?

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
		guard let swapProviders else { return }
		providerDidSelect(swapProviders[indexPath.item])
	}
}

extension SwapProvidersCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let swapProviders else { return 3 }
		return swapProviders.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = dequeueReusableCell(
			withReuseIdentifier: SwapProviderCell.cellReuseID,
			for: indexPath
		) as! SwapProviderCell
		if let swapProviders {
			cell.hideSkeletonView()
			cell.swapProviderVM = swapProviders[indexPath.item]
			if let selectedProvider, swapProviders[indexPath.item].provider == selectedProvider.provider {
				if let bestProvider, selectedProvider.provider == bestProvider.provider {
					cell.cellStyle = .bestRate
				} else {
					cell.cellStyle = .selected
				}
			} else {
				cell.cellStyle = .normal
			}
		} else {
			cell.swapProviderVM = nil
			cell.cellStyle = .normal
			cell.showSkeletonView()
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
