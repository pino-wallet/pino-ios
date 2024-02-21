//
//  CDUnwrapETHActivity+CoreDataProperties.swift
//
//
//  Created by Amir Kazemi on 2/21/24.
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
