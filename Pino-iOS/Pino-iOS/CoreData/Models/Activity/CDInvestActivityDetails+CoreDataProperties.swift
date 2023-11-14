//
//  CDInvestActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import Foundation
import CoreData


extension CDInvestActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInvestActivityDetails> {
        return NSFetchRequest<CDInvestActivityDetails>(entityName: "CDInvestActivityDetails")
    }

    @NSManaged public var activity: CDInvestActivity?

}
