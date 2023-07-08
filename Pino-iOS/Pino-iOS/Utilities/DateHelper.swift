//
//  TimeHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/5/23.
//

import Foundation

class DateHelper {
    public func calculateDistanceBetweenTwoDates(previousDate: Date, currentDate: Date = Date()) -> String {
		let previousDateTimeInterval = currentDate.timeIntervalSince(previousDate)
		let dateComponentsformatter = DateComponentsFormatter()
		dateComponentsformatter.unitsStyle = .full
		let timeBetweenTwoDates = Calendar.current.dateComponents(
			[.day, .hour, .minute],
			from: previousDate,
			to: currentDate
		)
		if timeBetweenTwoDates.day! > 0 {
			dateComponentsformatter.allowedUnits = [.day]
		} else if timeBetweenTwoDates.hour! > 0 {
			dateComponentsformatter.allowedUnits = [.hour]
		} else {
			dateComponentsformatter.allowedUnits = [.minute]
		}

		return "\(dateComponentsformatter.string(from: previousDateTimeInterval)!) ago"
	}
}
