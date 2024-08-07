//
//  CDSwapActivityDetails+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDSwapActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDSwapActivityDetails> {
		NSFetchRequest<CDSwapActivityDetails>(entityName: "CDSwapActivityDetails")
	}

	@NSManaged
	public var activityProtool: String
	@NSManaged
	public var activity: CDSwapActivity?
	@NSManaged
	public var from_token: CDActivityDetailsToken
	@NSManaged
	public var to_token: CDActivityDetailsToken
}

extension CDSwapActivityDetails: Identifiable {}
