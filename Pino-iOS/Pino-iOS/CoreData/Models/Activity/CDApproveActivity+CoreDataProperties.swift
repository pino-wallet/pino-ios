//
//  CDApproveActivity+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDApproveActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDApproveActivity> {
		NSFetchRequest<CDApproveActivity>(entityName: "CDApproveActivity")
	}

	@NSManaged
	public var details: CDApproveActivityDetails
}
