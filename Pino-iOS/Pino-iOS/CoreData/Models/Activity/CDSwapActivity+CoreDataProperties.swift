//
//  CDSwapActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import Foundation
import CoreData


extension CDSwapActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSwapActivity> {
        return NSFetchRequest<CDSwapActivity>(entityName: "CDSwapActivity")
    }

    @NSManaged public var details: CDSwapActivityDetails

}
