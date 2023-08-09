//
//  CDActivityDetailsToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDActivityDetailsToken {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDActivityDetailsToken> {
		NSFetchRequest<CDActivityDetailsToken>(entityName: "CDActivityDetailsToken")
	}

	@NSManaged
	public var amount: String
	@NSManaged
	public var tokenId: String
	@NSManaged
	public var details_from: CDSwapActivityDetails?
	@NSManaged
	public var details_to: CDSwapActivityDetails?
}

extension CDActivityDetailsToken: Identifiable {}
