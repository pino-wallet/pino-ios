//
//  Date+Extension.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/25/23.
//

import Foundation

extension Date {
	func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
		calendar.dateComponents(Set(components), from: self)
	}

	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		calendar.component(component, from: self)
	}

	func monthName() -> String {
		let df = DateFormatter()
		df.setLocalizedDateFormatFromTemplate("MMM")
		return df.string(from: self)
	}

	static func - (lhs: Date, rhs: Int) -> Date {
		Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
	}
}
