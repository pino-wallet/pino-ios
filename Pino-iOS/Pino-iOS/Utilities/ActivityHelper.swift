//
//  ActivitySeparatorWithTime.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/3/23.
//

import Foundation

class ActivityHelper {
	// MARK: - TypeAliases

	public typealias SeparatedActivitiesType = [(title: String, activities: [ActivityCellViewModel])]
	public typealias SeparatedActivitiesWithDayType = [Int: [ActivityCellViewModel]]

	// MARK: - Public Methods

	public func getActivityDate(activityBlockTime: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter.date(from: activityBlockTime)!
	}

	public func separateActivitiesByTime(activities: [ActivityCellViewModel]) -> SeparatedActivitiesType {
		var separatedActivitiesWithDay: SeparatedActivitiesWithDayType

		separatedActivitiesWithDay = separateActivitiesByDay(activities: activities)

		return sortSeparatedActivities(separatedActivitiesWithDay: separatedActivitiesWithDay)
	}
    
    public func getNewActivitiesInfo(separatedActivities: SeparatedActivitiesType, newSeparatedActivities: SeparatedActivitiesType) -> (indexPaths: [IndexPath], sections: [IndexSet], finallSeparatedActivities: SeparatedActivitiesType) {
        var indexPaths = [IndexPath]()
        var indexSets: [IndexSet] = []
        var finallSeparatedActivities: SeparatedActivitiesType = separatedActivities
        
        for newSeparatedActivity in newSeparatedActivities {
            let foundSectionIndex = finallSeparatedActivities.firstIndex { $0.title == newSeparatedActivity.title }
            if foundSectionIndex != nil {
                finallSeparatedActivities[foundSectionIndex!].activities.append(contentsOf: newSeparatedActivity.activities)
                finallSeparatedActivities[foundSectionIndex!].activities =  finallSeparatedActivities[foundSectionIndex!].activities.sorted(by: {getActivityDate(activityBlockTime: $0.blockTime).timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.blockTime).timeIntervalSince1970 })
                for (index, item) in finallSeparatedActivities[foundSectionIndex!].activities.enumerated() {
                    if newSeparatedActivity.activities.contains(where: {item.defaultActivityModel.txHash == $0.defaultActivityModel.txHash}) {
                        indexPaths.append(IndexPath(row: index, section: foundSectionIndex!))
                    }
                }
            } else {
                finallSeparatedActivities.append(newSeparatedActivity)
                finallSeparatedActivities = finallSeparatedActivities.sorted(by: {getActivityDate(activityBlockTime: $0.activities[0].blockTime).timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.activities[0].blockTime).timeIntervalSince1970})
                let foundSectionIndex = finallSeparatedActivities.firstIndex(where: {$0.title == newSeparatedActivity.title})
                finallSeparatedActivities[foundSectionIndex!].activities =  finallSeparatedActivities[foundSectionIndex!].activities.sorted(by: {getActivityDate(activityBlockTime: $0.blockTime).timeIntervalSince1970 > getActivityDate(activityBlockTime: $1.blockTime).timeIntervalSince1970 })
                indexSets.append(IndexSet(integer: foundSectionIndex!))
                for _ in finallSeparatedActivities[foundSectionIndex!].activities {
                    indexPaths.append(IndexPath(row: finallSeparatedActivities[foundSectionIndex!].activities.count - 1, section: foundSectionIndex!))
                }
            }
        }
        
        return (indexPaths: indexPaths, sections: indexSets, finallSeparatedActivities: finallSeparatedActivities)
    }

	// MARK: - Private Methods

	private func separateActivitiesByDay(activities: [ActivityCellViewModel]) -> SeparatedActivitiesWithDayType {
		let currentDate = Date()
		var activityDate: Date
		var daysBetweenNowAndActivityTime: Int
		var result: SeparatedActivitiesWithDayType = [:]

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

	private func sortSeparatedActivities(separatedActivitiesWithDay: SeparatedActivitiesWithDayType)
		-> SeparatedActivitiesType {
		var result: SeparatedActivitiesType = []
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
