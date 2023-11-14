//
//  CDBorrowActivity+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import Foundation
import CoreData


extension CDBorrowActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBorrowActivity> {
        return NSFetchRequest<CDBorrowActivity>(entityName: "CDBorrowActivity")
    }

    @NSManaged public var details: CDBorrowActivityDetails

}
