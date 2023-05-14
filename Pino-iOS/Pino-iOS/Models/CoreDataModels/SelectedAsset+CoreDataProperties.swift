//
//  SelectedAsset+CoreDataProperties.swift
//
//
//  Created by Sobhan Eskandari on 5/13/23.
//
//

import CoreData
import Foundation

extension SelectedAsset {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<SelectedAsset> {
		NSFetchRequest<SelectedAsset>(entityName: "SelectedAsset")
	}

	@NSManaged
	public var id: String?
}
