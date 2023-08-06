//
//  CoreDataSwapActivityDetails+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataSwapActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivityDetails> {
		NSFetchRequest<CoreDataSwapActivityDetails>(entityName: "CoreDataSwapActivityDetails")
	}

	@NSManaged
	public var activityProtool: String
	@NSManaged
	public var userID: String
	@NSManaged
	public var activity: CoreDataSwapActivity
	@NSManaged
	public var from_token: CoreDataSwapActivityDetailsFromToken
	@NSManaged
	public var to_token: CoreDataSwapActivityDetailsToToken
}

extension CoreDataSwapActivityDetails: Identifiable {}