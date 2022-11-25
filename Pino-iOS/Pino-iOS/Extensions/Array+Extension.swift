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
