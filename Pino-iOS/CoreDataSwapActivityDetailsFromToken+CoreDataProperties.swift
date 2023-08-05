//
//  CoreDataSwapActivityDetailsFromToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataSwapActivityDetailsFromToken {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivityDetailsFromToken> {
		NSFetchRequest<CoreDataSwapActivityDetailsFromToken>(entityName: "CoreDataSwapActivityDetailsFromToken")
	}

	@NSManaged
	public var details: CoreDataSwapActivityDetails?
}
