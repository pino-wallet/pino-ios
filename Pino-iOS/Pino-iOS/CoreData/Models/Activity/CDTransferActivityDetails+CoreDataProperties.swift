//
//  CDTransferActivityDetails+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDTransferActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDTransferActivityDetails> {
		NSFetchRequest<CDTransferActivityDetails>(entityName: "CDTransferActivityDetails")
	}

	@NSManaged
	public var amount: String
	@NSManaged
	public var from: String
	@NSManaged
	public var to: String
	@NSManaged
	public var tokenID: String
	@NSManaged
	public var activity: CDTransferActivity?
}

extension CDTransferActivityDetails: Identifiable {}
