//
//  FlowLayout+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/17/23.
//

import UIKit

extension UICollectionViewFlowLayout {
	// MARK: Initializers

	convenience init(scrollDirection: UICollectionView.ScrollDirection) {
		self.init()
		self.minimumLineSpacing = 0
		self.scrollDirection = scrollDirection
		self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
	}
}
