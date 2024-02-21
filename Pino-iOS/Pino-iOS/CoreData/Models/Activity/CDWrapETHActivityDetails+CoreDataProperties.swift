//
//  CDWrapETHActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir Kazemi on 2/21/24.
//
//

import CoreData
import Foundation

extension CDWrapETHActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDWrapETHActivityDetails> {
		NSFetchRequest<CDWrapETHActivityDetails>(entityName: "CDWrapETHActivityDetails")
	}

	@NSManaged
	public var amount: String
	@NSManaged
	public var activity: CDWrapETHActivity?
}
