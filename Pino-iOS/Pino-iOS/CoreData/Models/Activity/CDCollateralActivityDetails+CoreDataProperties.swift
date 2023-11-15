//
//  CDCollateralActivityDetails+CoreDataProperties.swift
//  
//
//  Created by Amir hossein kazemi seresht on 11/15/23.
//
//

import Foundation
import CoreData


extension CDCollateralActivityDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCollateralActivityDetails> {
        return NSFetchRequest<CDCollateralActivityDetails>(entityName: "CDCollateralActivityDetails")
    }

    @NSManaged public var activityProtocol: String
    @NSManaged public var activity: CDCollateralActivity?
    @NSManaged public var tokens: Set<CDActivityDetailsToken>

}

// MARK: Generated accessors for tokens
extension CDCollateralActivityDetails {

    @objc(addTokensObject:)
    @NSManaged public func addToTokens(_ value: CDActivityDetailsToken)

    @objc(removeTokensObject:)
    @NSManaged public func removeFromTokens(_ value: CDActivityDetailsToken)

    @objc(addTokens:)
    @NSManaged public func addToTokens(_ values: NSSet)

    @objc(removeTokens:)
    @NSManaged public func removeFromTokens(_ values: NSSet)

}
