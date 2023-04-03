//
//  LineChartDelegate.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/1/23.
//

protocol LineChartDelegate: AnyObject {
	func valueDidChange(pointValue: Double?, valueChangePercentage: Double?)
}
