//
//  CDWrapETHActivity+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 2/24/24.
//
//

import CoreData
import Foundation

extension CDWrapETHActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDWrapETHActivity> {
		NSFetchRequest<CDWrapETHActivity>(entityName: "CDWrapETHActivity")
	}

	@NSManaged
	public var details: CDWrapETHActivityDetails
}
