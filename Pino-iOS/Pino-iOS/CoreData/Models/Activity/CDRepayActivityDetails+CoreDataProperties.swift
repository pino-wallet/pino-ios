//
//  CDRepayActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDRepayActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDRepayActivityDetails> {
		NSFetchRequest<CDRepayActivityDetails>(entityName: "CDRepayActivityDetails")
	}

	@NSManaged
	public var activityProtocol: String
	@NSManaged
	public var activity: CDRepayActivity?
	@NSManaged
	public var repaid_token: CDActivityDetailsToken
	@NSManaged
	public var repaid_with_token: CDActivityDetailsToken
}
