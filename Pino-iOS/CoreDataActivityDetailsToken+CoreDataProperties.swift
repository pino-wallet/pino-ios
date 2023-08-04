//
//  CoreDataActivityDetailsToken+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/4/23.
//
//

import Foundation
import CoreData


extension CoreDataActivityDetailsToken {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataActivityDetailsToken> {
        return NSFetchRequest<CoreDataActivityDetailsToken>(entityName: "CoreDataActivityDetailsToken")
    }

    @NSManaged public var amount: String?
    @NSManaged public var tokenId: String?

}

extension CoreDataActivityDetailsToken : Identifiable {

}
