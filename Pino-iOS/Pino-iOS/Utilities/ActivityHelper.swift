//
//  ActivitySeparatorWithTime.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/3/23.
//

import Foundation


class ActivityHelper {
    // MARK: - TypeAliases
    public typealias separatedActivitiesType = [(title: String, activities: [ActivityCellViewModel])]
    // MARK: - Public Methods
    public func getActivityDate(activityBlockTime: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: activityBlockTime)!
    }
    public func separateActivitiesByTime(activities: [ActivityCellViewModel]) -> separatedActivitiesType {
        var result: separatedActivitiesType = []
        var separatedActivitiesWithTime = [Int : [ActivityCellViewModel]]()
        var activityDate: Date
        var daysBetweenNowAndActivityTime: Int
        var activityGroupTitle: String
        var timeIntervalSince: TimeInterval
        var firstActivityInGroupDate: Date
        let currentDate = Date()
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .full
        dateComponentsFormatter.allowedUnits = [.day]
        
        for activity in activities {
            activityDate = getActivityDate(activityBlockTime: activity.blockTime)
            daysBetweenNowAndActivityTime = Calendar.current.dateComponents([.day], from: activityDate, to: currentDate).day!
            if separatedActivitiesWithTime[daysBetweenNowAndActivityTime] != nil {
                separatedActivitiesWithTime[daysBetweenNowAndActivityTime]?.append(activity)
            } else {
                separatedActivitiesWithTime[daysBetweenNowAndActivityTime] = [activity]
            }
        }
        
        let sortedSeparatedActivitiesKeys = separatedActivitiesWithTime.keys.sorted()
        
        for activityGroupKey in sortedSeparatedActivitiesKeys {
            guard let activityGroup = separatedActivitiesWithTime[activityGroupKey] else {
                fatalError("there is no activity in separated activities")
            }
            
            if activityGroupKey == 0 {
                activityGroupTitle = "Today"
            } else if activityGroupKey == 1 {
                activityGroupTitle = "Yesterday"
            } else {
                firstActivityInGroupDate = getActivityDate(activityBlockTime: activityGroup[0].blockTime)
                timeIntervalSince = currentDate.timeIntervalSince(firstActivityInGroupDate)
                activityGroupTitle = "\(dateComponentsFormatter.string(from: timeIntervalSince)!) ago"
            }
            result.append((title: activityGroupTitle, activities: activityGroup))
        }
        return result
    }
}

