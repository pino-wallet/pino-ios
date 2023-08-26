//
//  File.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/22/23.
//

import Combine
import UIKit

class BorrowingTokensCollectionView: UICollectionView {
	// MARK: - Public Properties

	public var borrowingDetailsVM: BorrowingDetailsViewModel

	// MARK: - Private Properties

	private var borrowingDetailsProperties: BorrowingPropertiesViewModel!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(borrowingDetailsVM: BorrowingDetailsViewModel) {
		self.borrowingDetailsVM = borrowingDetailsVM

		let flowLayout = UICollectionViewFlowLayout(
			scrollDirection: .horizontal,
			sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		)

		super.init(frame: .zero, collectionViewLayout: flowLayout)
		flowLayout.collectionView?.backgroundColor = .Pino.secondaryBackground
		flowLayout.collectionView?.showsHorizontalScrollIndicator = false
		flowLayout.minimumLineSpacing = 8
		flowLayout.minimumInteritemSpacing = 8

		configureCollectionView()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func configureCollectionView() {
		register(BorrowingTokenCell.self, forCellWithReuseIdentifier: BorrowingTokenCell.cellReuseId)

		delegate = self
		dataSource = self
	}

	private func setupBindings() {
		borrowingDetailsVM.$properties.sink { newBorrowingDetailsProperties in
			guard let newBorrowingDetailsProperties = newBorrowingDetailsProperties else {
				return
			}
			self.borrowingDetailsProperties = newBorrowingDetailsProperties
			self.reloadData()
		}.store(in: &cancellables)
	}
}

extension BorrowingTokensCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		borrowingDetailsProperties.borrowingAssetsDetailList.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let tokenCell = dequeueReusableCell(
			withReuseIdentifier: BorrowingTokenCell.cellReuseId,
			for: indexPath
		) as! BorrowingTokenCell

		tokenCell
			.borrowingTokenVM = BorrowingTokenCellViewModel(
				borrowinTokenModel: borrowingDetailsProperties
					.borrowingAssetsDetailList[indexPath.item]
			)
		tokenCell.progressBarColor = borrowingDetailsProperties.progressBarColor

		return tokenCell
	}
}

extension BorrowingTokensCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 32, height: 32)
	}
}
