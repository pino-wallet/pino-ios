//
//  Decimal+Extension.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 4/4/23.
//

import Foundation

extension Decimal {
	/// This function is removes "." in Decimal numbers
	///  Sample : Converts 234234.34343 -> 23423434343
	///  Suitable for writing tests
	/// - Returns: Trimmed Decimal as s String without  "."
	public func withoutDeicmalDot() -> String {
		String(describing: self).replacingOccurrences(of: ".", with: "")
	}
}
