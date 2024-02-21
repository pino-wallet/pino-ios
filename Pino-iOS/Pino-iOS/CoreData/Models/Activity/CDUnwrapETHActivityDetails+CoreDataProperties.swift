//
//  CDUnwrapETHActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir Kazemi on 2/21/24.
//
//

import Foundation
import CoreData


extension CDUnwrapETHActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUnwrapETHActivityDetails> {
        return NSFetchRequest<CDUnwrapETHActivityDetails>(entityName: "CDUnwrapETHActivityDetails")
    }

    @NSManaged public var amount: String
    @NSManaged public var activity: CDUnwrapETHActivity?

}
