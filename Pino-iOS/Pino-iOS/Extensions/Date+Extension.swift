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
		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
		return dateFormatter.string(from: self)
	}

	func getHourMinuteTime() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
		return dateFormatter.string(from: self)
	}

	static func - (lhs: Date, rhs: Int) -> Date {
		Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
	}

	public var timeZoneSecondsFromGMT: Int {
		TimeZone.current.secondsFromGMT()
	}

	public var timeZoneIdentifier: String {
		TimeZone.current.identifier
	}

	public var serverFormattedDate: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.locale = Locale(identifier: Date().timeZoneIdentifier)
		dateFormatter.timeZone = TimeZone(secondsFromGMT: Date().timeZoneSecondsFromGMT)
		return dateFormatter.string(from: self)
	}

	public var relativeDate: String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full

		let relativeDate = formatter.localizedString(for: self, relativeTo: Date.now)

		return relativeDate.replacingOccurrences(of: "minute", with: "min")
	}
}
