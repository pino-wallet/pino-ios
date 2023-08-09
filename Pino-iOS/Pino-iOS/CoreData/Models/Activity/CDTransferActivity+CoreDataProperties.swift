//
//  CDTransferActivity+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/8/23.
//
//

import Foundation
import CoreData


extension CDTransferActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransferActivity> {
        return NSFetchRequest<CDTransferActivity>(entityName: "CDTransferActivity")
    }

    @NSManaged public var details: CDTransferActivityDetails

}
