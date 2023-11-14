//
//  CDWithdrawActivity+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import Foundation
import CoreData


extension CDWithdrawActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWithdrawActivity> {
        return NSFetchRequest<CDWithdrawActivity>(entityName: "CDWithdrawActivity")
    }

    @NSManaged public var details: CDWithdrawActivityDetails

}
