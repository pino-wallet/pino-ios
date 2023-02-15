//
//  FlowLayout+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/17/23.
//

import UIKit

extension UICollectionViewFlowLayout {
	// MARK: Initializers

	convenience init(
		scrollDirection: UICollectionView.ScrollDirection,
		minimumLineSpacing: CGFloat = 0,
		sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	) {
		self.init()
		self.minimumLineSpacing = minimumLineSpacing
		self.scrollDirection = scrollDirection
		self.sectionInset = sectionInset
		self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
	}
}
