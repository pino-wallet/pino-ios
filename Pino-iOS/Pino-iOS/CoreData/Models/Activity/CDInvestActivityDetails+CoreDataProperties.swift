//
//  CDInvestActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDInvestActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDInvestActivityDetails> {
		NSFetchRequest<CDInvestActivityDetails>(entityName: "CDInvestActivityDetails")
	}

	@NSManaged
	public var activity: CDInvestActivity?
}
