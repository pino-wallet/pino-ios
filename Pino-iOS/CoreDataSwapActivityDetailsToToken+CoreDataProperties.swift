//
//  CoreDataSwapActivityDetailsToToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/5/23.
//
//

import Foundation
import CoreData


extension CoreDataSwapActivityDetailsToToken {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataSwapActivityDetailsToToken> {
        return NSFetchRequest<CoreDataSwapActivityDetailsToToken>(entityName: "CoreDataSwapActivityDetailsToToken")
    }

    @NSManaged public var details: CoreDataSwapActivityDetails?

}
