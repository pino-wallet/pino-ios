//
//  SelectedAsset+CoreDataProperties.swift
//  
//
//  Created by Sobhan Eskandari on 5/13/23.
//
//

import Foundation
import CoreData


extension SelectedAsset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedAsset> {
        return NSFetchRequest<SelectedAsset>(entityName: "SelectedAsset")
    }

    @NSManaged public var id: String?

}
