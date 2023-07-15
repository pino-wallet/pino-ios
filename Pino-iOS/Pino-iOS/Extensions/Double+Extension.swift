//
//  Double+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 5/1/23.
//

import Foundation

extension Double {
	func roundToPlaces(_ places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}

