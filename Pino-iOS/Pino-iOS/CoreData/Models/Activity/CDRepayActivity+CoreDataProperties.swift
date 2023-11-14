//
//  CDRepayActivity+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDRepayActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDRepayActivity> {
		NSFetchRequest<CDRepayActivity>(entityName: "CDRepayActivity")
	}

	@NSManaged
	public var details: CDRepayActivityDetails
}
