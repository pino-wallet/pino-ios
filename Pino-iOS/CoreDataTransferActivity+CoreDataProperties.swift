//
//  CoreDataTransferActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataTransferActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataTransferActivity> {
		NSFetchRequest<CoreDataTransferActivity>(entityName: "CoreDataTransferActivity")
	}

	@NSManaged
	public var details: CoreDataTransferActivityDetails?
}
