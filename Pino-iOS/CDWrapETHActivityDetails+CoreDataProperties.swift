//
//  CDWrapETHActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 2/24/24.
//
//

import Foundation
import CoreData


extension CDWrapETHActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWrapETHActivityDetails> {
        return NSFetchRequest<CDWrapETHActivityDetails>(entityName: "CDWrapETHActivityDetails")
    }

    @NSManaged public var amount: String
    @NSManaged public var activity: CDWrapETHActivity?

}
