//
//  SwapDelegate.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/3/23.
//

import Foundation

protocol SwapDelegate: AnyObject {
	func selectedTokenDidChange()
	func swapAmountDidCalculate()
	func swapAmountCalculating()
}
