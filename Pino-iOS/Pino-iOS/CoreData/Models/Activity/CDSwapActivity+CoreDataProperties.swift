//
//  CDSwapActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import CoreData
import Foundation

extension CDSwapActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDSwapActivity> {
		NSFetchRequest<CDSwapActivity>(entityName: "CDSwapActivity")
	}

	@NSManaged
	public var details: CDSwapActivityDetails
}
