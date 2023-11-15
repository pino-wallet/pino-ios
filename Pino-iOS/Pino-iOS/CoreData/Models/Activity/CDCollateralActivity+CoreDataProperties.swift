//
//  CDCollateralActivity+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/15/23.
//
//

import Foundation
import CoreData


extension CDCollateralActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCollateralActivity> {
        return NSFetchRequest<CDCollateralActivity>(entityName: "CDCollateralActivity")
    }

    @NSManaged public var details: CDCollateralActivityDetails

}
