//
//  CoreDataActivityParent+CoreDataProperties.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/4/23.
//
//

import Foundation
import CoreData


extension CoreDataActivityParent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataActivityParent> {
        return NSFetchRequest<CoreDataActivityParent>(entityName: "CoreDataActivityParent")
    }

    @NSManaged public var blockTime: String?
    @NSManaged public var failed: Bool
    @NSManaged public var fromAddress: String?
    @NSManaged public var gasPrice: String?
    @NSManaged public var gasUsed: String?
    @NSManaged public var toAddress: String?
    @NSManaged public var txHash: String?
    @NSManaged public var type: String?

}

extension CoreDataActivityParent : Identifiable {

}
