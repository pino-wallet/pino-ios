//
//  CDTransferActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDTransferActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDTransferActivity> {
		NSFetchRequest<CDTransferActivity>(entityName: "CDTransferActivity")
	}

	@NSManaged
	public var details: CDTransferActivityDetails
}
