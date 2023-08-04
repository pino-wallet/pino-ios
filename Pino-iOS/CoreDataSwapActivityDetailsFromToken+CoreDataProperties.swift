//
//  CoreDataSwapActivityDetailsFromToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/4/23.
//
//

import Foundation
import CoreData


extension CoreDataSwapActivityDetailsFromToken {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivityDetailsFromToken> {
        return NSFetchRequest<CoreDataSwapActivityDetailsFromToken>(entityName: "CoreDataSwapActivityDetailsFromToken")
    }

    @NSManaged public var details: CoreDataSwapActivityDetails?

}
