//
//  SuggestedSeedPhraseCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/23/22.
//
// swiftlint: disable force_cast

import UIKit

class SuggestedSeedPhraseCollectionView: UICollectionView {
	// MARK: Public Properties

	public var suggestedSeedPhrase: [String] = [] {
		didSet {
			reloadData()
		}
	}

	public var seedPhraseDidSelect: ((String) -> Void)?

	// MARK: Initializers

	convenience init() {
		// Set flow layout for collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		flowLayout.scrollDirection = .horizontal
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
		self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 48), collectionViewLayout: flowLayout)

		configCollectionView()
		setupStyle()
	}

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func configCollectionView() {
		register(SuggestedSeedPhraseCell.self, forCellWithReuseIdentifier: SuggestedSeedPhraseCell.cellReuseID)
		dataSource = self
		delegate = self
		showsHorizontalScrollIndicator = false
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
	}
}

// MARK: Collection View DataSource

extension SuggestedSeedPhraseCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		min(10, suggestedSeedPhrase.count)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let suggestedSeedPhraseCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: SuggestedSeedPhraseCell.cellReuseID,
			for: indexPath
		) as! SuggestedSeedPhraseCell
		suggestedSeedPhraseCell.suggestedWord = suggestedSeedPhrase[indexPath.item]
		return suggestedSeedPhraseCell
	}
}

// MARK: Collection View Delegate

extension SuggestedSeedPhraseCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let seedPhraseDidSelect {
			let suggestedSeedPhraseCell = collectionView.cellForItem(at: indexPath) as! SuggestedSeedPhraseCell
			seedPhraseDidSelect(suggestedSeedPhraseCell.suggestedWord)
		}
	}
}
