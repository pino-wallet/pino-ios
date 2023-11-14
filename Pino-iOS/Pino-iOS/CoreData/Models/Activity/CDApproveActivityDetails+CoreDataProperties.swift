//
//  CDApproveActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDApproveActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDApproveActivityDetails> {
		NSFetchRequest<CDApproveActivityDetails>(entityName: "CDApproveActivityDetails")
	}

	@NSManaged
	public var amount: String
	@NSManaged
	public var owner: String
	@NSManaged
	public var spender: String
	@NSManaged
	public var tokenID: String
	@NSManaged
	public var activity: CDApproveActivity?
}
