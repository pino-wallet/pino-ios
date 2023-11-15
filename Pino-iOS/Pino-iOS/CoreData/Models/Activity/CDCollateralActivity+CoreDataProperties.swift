//
//  CDCollateralActivity+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/15/23.
//
//

import CoreData
import Foundation

extension CDCollateralActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDCollateralActivity> {
		NSFetchRequest<CDCollateralActivity>(entityName: "CDCollateralActivity")
	}

	@NSManaged
	public var details: CDCollateralActivityDetails
}
