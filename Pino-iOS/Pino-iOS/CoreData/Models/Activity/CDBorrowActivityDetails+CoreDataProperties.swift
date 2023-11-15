//
//  CDBorrowActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDBorrowActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDBorrowActivityDetails> {
		NSFetchRequest<CDBorrowActivityDetails>(entityName: "CDBorrowActivityDetails")
	}

	@NSManaged
	public var activityProtocol: String
	@NSManaged
	public var activity: CDBorrowActivity?
	@NSManaged
	public var token: CDActivityDetailsToken
}
