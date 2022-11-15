//
//  SecretPhraseCenteredFlowLayout.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/14/22.
//
// swiftlint: disable force_cast

import UIKit

class SecretPhraseCenteredFlowLayout: UICollectionViewFlowLayout {
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let layoutAttributesForElements = super.layoutAttributesForElements(in: rect) else {
			return nil
		}
		guard let collectionView = collectionView else {
			return layoutAttributesForElements
		}
		// Group copies of the elements from the same row
		let (representedElements, cells) = groupElements(layoutAttributes: layoutAttributesForElements)

		// Reposition all elements
		return representedElements + cells.flatMap { group -> [UICollectionViewLayoutAttributes] in
			guard let section = group.first?.indexPath.section else {
				return group
			}
			let evaluatedSectionInset = evaluatedSectionInsetForSection(at: section)
			let evaluatedMinimumInteritemSpacing = evaluatedMinimumInteritemSpacingForSection(at: section)
			let evaluatedCollectionView = (
				collectionView.bounds.width +
					evaluatedSectionInset.left -
					evaluatedSectionInset.right -
					group.reduce(0) { $0 + $1.frame.size.width } -
					CGFloat(group.count - 1) *
					evaluatedMinimumInteritemSpacing
			)
			var origin = evaluatedCollectionView / 2

			// Reposition each element of a group
			return group.map {
				$0.frame.origin.x = origin
				origin += $0.frame.size.width + evaluatedMinimumInteritemSpacing
				return $0
			}
		}
	}

	private func groupElements(layoutAttributes: [UICollectionViewLayoutAttributes])
		-> ([UICollectionViewLayoutAttributes], [[UICollectionViewLayoutAttributes]]) {
		var representedElements: [UICollectionViewLayoutAttributes] = []
		var cells: [[UICollectionViewLayoutAttributes]] = [[]]
		var previousFrame: CGRect?

		for layoutAttribute in layoutAttributes {
			guard layoutAttribute.representedElementKind == nil else {
				representedElements.append(layoutAttribute)
				continue
			}
			// Required to avoid "UICollectionViewFlowLayout cache mismatched frame"
			let currentItemAttributes = layoutAttribute.copy() as! UICollectionViewLayoutAttributes

			// If the current frame, once stretched to the full row doesn't intersect the previous frame then they are on
			// different rows
			if let previousFrame = previousFrame {
				let currentFrame = CGRect(
					x: -.greatestFiniteMagnitude,
					y: previousFrame.origin.y,
					width: .infinity,
					height: previousFrame.size.height
				)
				if !currentItemAttributes.frame.intersects(currentFrame) {
					cells.append([])
				}
			}

			cells[cells.endIndex - 1].append(currentItemAttributes)
			previousFrame = currentItemAttributes.frame
		}
		return (representedElements, cells)
	}
}

extension UICollectionViewFlowLayout {
	func evaluatedSectionInsetForSection(at section: Int) -> UIEdgeInsets {
		let collectionViewDelegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout
		let collectionViewEdgeInset = collectionViewDelegate?.collectionView?(
			collectionView!,
			layout: self,
			insetForSectionAt: section
		)
		return collectionViewEdgeInset ?? sectionInset
	}

	func evaluatedMinimumInteritemSpacingForSection(at section: Int) -> CGFloat {
		let collectionViewDelegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout
		let collectionViewEdgeInset = collectionViewDelegate?.collectionView?(
			collectionView!,
			layout: self,
			minimumInteritemSpacingForSectionAt: section
		)
		return collectionViewEdgeInset ?? minimumInteritemSpacing
	}
}
