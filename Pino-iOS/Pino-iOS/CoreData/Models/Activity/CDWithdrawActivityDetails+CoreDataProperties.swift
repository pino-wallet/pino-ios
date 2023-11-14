//
//  CDWithdrawActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import Foundation
import CoreData


extension CDWithdrawActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWithdrawActivityDetails> {
        return NSFetchRequest<CDWithdrawActivityDetails>(entityName: "CDWithdrawActivityDetails")
    }

    @NSManaged public var activity: CDWithdrawActivity?

}
