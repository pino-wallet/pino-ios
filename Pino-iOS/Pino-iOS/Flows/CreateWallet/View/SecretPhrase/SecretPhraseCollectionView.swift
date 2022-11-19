//
//  SecretPhraseCollectionView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//
// swiftlint: disable force_cast

import UIKit

class SecretPhraseCollectionView: UICollectionView {
	// MARK: Public Properties

	public var words: [String] = [] {
		didSet {
			reloadData()
		}
	}

	public var cellStyle: SecretPhraseCell.Style = .regular
	public var wordSelected: ((String) -> Void)?

	// MARK: Initializers

	convenience init() {
		// Set flow layout for collection view
		let flowLayout = SecretPhraseCenteredFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		flowLayout.minimumInteritemSpacing = 8
		flowLayout.minimumLineSpacing = 8
		flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		self.init(frame: .zero, collectionViewLayout: flowLayout)

		registerCell()
		setupStyle()
	}

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private Methods

	private func registerCell() {
		register(SecretPhraseCell.self, forCellWithReuseIdentifier: SecretPhraseCell.reuseID)
		dataSource = self
		delegate = self
	}

	private func setupStyle() {
		backgroundColor = .Pino.clear
	}

	// MARK: UI Overrides

	override func layoutSubviews() {
		super.layoutSubviews()
		if !__CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
			invalidateIntrinsicContentSize()
		}
	}

	override var intrinsicContentSize: CGSize {
		contentSize
	}
}

// MARK: Collection View DataSource

extension SecretPhraseCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		words.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let index = indexPath.item
		let secretPhraseCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: SecretPhraseCell.reuseID,
			for: indexPath
		) as! SecretPhraseCell

		switch cellStyle {
		case .regular:
			secretPhraseCell.seedPhrase = DefaultSeedPhrase(sequence: index + 1, title: words[index])
		case .unordered:
			secretPhraseCell.seedPhrase = UnorderedSeedPhrase(title: words[index])
		case .empty:
			secretPhraseCell.seedPhrase = EmptySeedPhrase()
		}
		return secretPhraseCell
	}
}

// MARK: Collection View Delegate

extension SecretPhraseCollectionView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let index = indexPath.item
		if let wordSelected = wordSelected {
			wordSelected(words[index])
		}
	}
}
