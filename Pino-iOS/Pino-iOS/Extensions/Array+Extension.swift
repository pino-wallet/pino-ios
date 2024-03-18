//
//  Array+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/25/22.
//

import Foundation

// Checks if index is valid in array
extension Array {
	func isIndexValid(index: Int) -> Bool {
		indices.contains(index)
	}
}

extension FloatingPoint {
	var whole: Self { modf(self).0 }
	var fraction: Self { modf(self).1 }
}

extension NSSet {
	func toArray<Item>() -> [Item] {
		let array = map { $0 as! Item }
		return array
	}
}

extension Array where Element == any ActivityModelProtocol {
	func indexOfActivityModel(activity: Element) -> Self.Index? {
		firstIndex(where: { $0.txHash.lowercased() == activity.txHash.lowercased() })
	}
}
