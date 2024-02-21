//
//  CDUnwrapETHActivity+CoreDataProperties.swift
//  
//
//  Created by Amir Kazemi on 2/21/24.
//
//

import Foundation
import CoreData


extension CDUnwrapETHActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUnwrapETHActivity> {
        return NSFetchRequest<CDUnwrapETHActivity>(entityName: "CDUnwrapETHActivity")
    }

    @NSManaged public var details: CDUnwrapETHActivityDetails

}
