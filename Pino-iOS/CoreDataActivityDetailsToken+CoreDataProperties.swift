//
//  CoreDataActivityDetailsToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataActivityDetailsToken {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataActivityDetailsToken> {
		NSFetchRequest<CoreDataActivityDetailsToken>(entityName: "CoreDataActivityDetailsToken")
	}

	@NSManaged
	public var amount: String?
	@NSManaged
	public var tokenId: String?
}

extension CoreDataActivityDetailsToken: Identifiable {}
