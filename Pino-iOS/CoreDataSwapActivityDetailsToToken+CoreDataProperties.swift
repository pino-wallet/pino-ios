//
//  CoreDataSwapActivityDetailsToToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataSwapActivityDetailsToToken {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivityDetailsToToken> {
		NSFetchRequest<CoreDataSwapActivityDetailsToToken>(entityName: "CoreDataSwapActivityDetailsToToken")
	}

	@NSManaged
	public var details: CoreDataSwapActivityDetails?
}
