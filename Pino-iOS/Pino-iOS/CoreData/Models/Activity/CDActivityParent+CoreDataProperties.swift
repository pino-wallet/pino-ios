//
//  CDActivityParent+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDActivityParent {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDActivityParent> {
		NSFetchRequest<CDActivityParent>(entityName: "CDActivityParent")
	}

	@NSManaged
	public var blockTime: String
	@NSManaged
	public var fromAddress: String
	@NSManaged
	public var gasPrice: String
	@NSManaged
	public var gasUsed: String
	@NSManaged
	public var toAddress: String
	@NSManaged
	public var txHash: String
	@NSManaged
	public var type: String
	@NSManaged
	public var accountAddress: String
	@NSManaged
	public var prevTxHash: String?
}

extension CDActivityParent: Identifiable {}
