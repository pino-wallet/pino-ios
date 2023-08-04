//
//  CoreDataTransferActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/4/23.
//
//

import Foundation
import CoreData


extension CoreDataTransferActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataTransferActivity> {
        return NSFetchRequest<CoreDataTransferActivity>(entityName: "CoreDataTransferActivity")
    }

    @NSManaged public var details: CoreDataTransferActivityDetails?

}
