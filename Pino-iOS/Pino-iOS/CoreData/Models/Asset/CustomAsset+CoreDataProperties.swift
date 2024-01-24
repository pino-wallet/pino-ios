//
//  CustomAsset+CoreDataProperties.swift
//
//
//  Created by Mohi Raoufi on 6/7/23.
//
//

import CoreData
import Foundation

extension CustomAsset {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CustomAsset> {
		NSFetchRequest<CustomAsset>(entityName: "CustomAsset")
	}

	@NSManaged
	public var id: String
	@NSManaged
	public var symbol: String
	@NSManaged
	public var name: String
	@NSManaged
	public var decimal: String
	@NSManaged
	public var accountAddress: String
}
