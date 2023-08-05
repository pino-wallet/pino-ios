//
//  CoreDataTransferActivityDetails+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataTransferActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataTransferActivityDetails> {
		NSFetchRequest<CoreDataTransferActivityDetails>(entityName: "CoreDataTransferActivityDetails")
	}

	@NSManaged
	public var amount: String?
	@NSManaged
	public var from: String?
	@NSManaged
	public var to: String?
	@NSManaged
	public var tokenID: String?
	@NSManaged
	public var activity: CoreDataTransferActivity?
}

extension CoreDataTransferActivityDetails: Identifiable {}
