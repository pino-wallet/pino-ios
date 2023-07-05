//
//  TimeHelper.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/5/23.
//

import Foundation

class DateHelper {
    public func calculateDistanceBetweenTwoDates(pastDate: Date) -> String {
        let currentDate = Date()
        let intervalSince = currentDate.timeIntervalSince(pastDate)
        let dateComponentsformatter = DateComponentsFormatter()
        dateComponentsformatter.unitsStyle = .full
        let betweenActivityAndCurrentTime = Calendar.current.dateComponents(
            [.day, .hour, .minute],
            from: pastDate,
            to: currentDate
        )
        if betweenActivityAndCurrentTime.day! > 0 {
            dateComponentsformatter.allowedUnits = [.day]
        } else if betweenActivityAndCurrentTime.hour! > 0 {
            dateComponentsformatter.allowedUnits = [.hour]
        } else {
            dateComponentsformatter.allowedUnits = [.minute]
        }

        return "\(dateComponentsformatter.string(from: intervalSince)!) ago"
    }
}
