//
//  CoreDataSwapActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import CoreData
import Foundation

extension CoreDataSwapActivity {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivity> {
		NSFetchRequest<CoreDataSwapActivity>(entityName: "CoreDataSwapActivity")
	}

	@NSManaged
	public var details: CoreDataSwapActivityDetails?
}
