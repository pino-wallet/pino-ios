//
//  CDUnwrapETHActivity+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 2/24/24.
//
//

import CoreData
import Foundation

extension CDUnwrapETHActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDUnwrapETHActivity> {
		NSFetchRequest<CDUnwrapETHActivity>(entityName: "CDUnwrapETHActivity")
	}

	@NSManaged
	public var details: CDUnwrapETHActivityDetails
}
