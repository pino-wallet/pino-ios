//
//  CDBorrowActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import Foundation
import CoreData


extension CDBorrowActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBorrowActivityDetails> {
        return NSFetchRequest<CDBorrowActivityDetails>(entityName: "CDBorrowActivityDetails")
    }

    @NSManaged public var activityProtocol: String
    @NSManaged public var activity: CDBorrowActivity?
    @NSManaged public var token: CDActivityDetailsToken

}
