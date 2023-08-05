//
//  CoreDataSwapActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import Foundation
import CoreData


extension CoreDataSwapActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivity> {
        return NSFetchRequest<CoreDataSwapActivity>(entityName: "CoreDataSwapActivity")
    }

    @NSManaged public var details: CoreDataSwapActivityDetails?

}
