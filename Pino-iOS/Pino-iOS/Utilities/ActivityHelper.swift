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
    public typealias separatedActivitiesWithDayType = [Int: [ActivityCellViewModel]]

	// MARK: - Public Methods

	public func getActivityDate(activityBlockTime: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter.date(from: activityBlockTime)!
	}

	public func separateActivitiesByTime(activities: [ActivityCellViewModel]) -> separatedActivitiesType {
        var separatedActivitiesWithDay: separatedActivitiesWithDayType
		
        separatedActivitiesWithDay = separateActivitiesByDay(activities: activities)

		return sortSeparatedActivities(separatedActivitiesWithDay: separatedActivitiesWithDay)
	}
    
    // MARK: - Private Methods
    
    private func separateActivitiesByDay(activities: [ActivityCellViewModel]) -> separatedActivitiesWithDayType {
        let currentDate = Date()
        var activityDate: Date
        var daysBetweenNowAndActivityTime: Int
        var result: separatedActivitiesWithDayType = [:]
        
        for activity in activities {
            activityDate = getActivityDate(activityBlockTime: activity.blockTime)
            daysBetweenNowAndActivityTime = Calendar.current.dateComponents([.day], from: activityDate, to: currentDate)
                .day!
            if result[daysBetweenNowAndActivityTime] != nil {
                result[daysBetweenNowAndActivityTime]?.append(activity)
            } else {
                result[daysBetweenNowAndActivityTime] = [activity]
            }
        }
        
        return result
    }
    
    private func sortSeparatedActivities(separatedActivitiesWithDay: separatedActivitiesWithDayType) -> separatedActivitiesType {
        var result: separatedActivitiesType = []
        var activityGroupTitle: String
        var firstActivityInGroupDate: Date
        
        let sortedSeparatedActivitiesKeys = separatedActivitiesWithDay.keys.sorted()

        for activityGroupKey in sortedSeparatedActivitiesKeys {
            guard let activityGroup = separatedActivitiesWithDay[activityGroupKey] else {
                fatalError("there is no activity in separated activities")
            }

            if activityGroupKey == 0 {
                activityGroupTitle = "Today"
            } else if activityGroupKey == 1 {
                activityGroupTitle = "Yesterday"
            } else {
                firstActivityInGroupDate = getActivityDate(activityBlockTime: activityGroup[0].blockTime)
                let dateHelper = DateHelper()
                activityGroupTitle = dateHelper.calculateDistanceBetweenTwoDates(previousDate: firstActivityInGroupDate)
            }
            result.append((title: activityGroupTitle, activities: activityGroup))
        }
        return result
    }
}
