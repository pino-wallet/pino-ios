//
//  CDInvestmentActivityDetails+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 11/14/23.
//
//

import CoreData
import Foundation

extension CDInvestmentActivityDetails {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<CDInvestmentActivityDetails> {
		NSFetchRequest<CDInvestmentActivityDetails>(entityName: "CDInvestmentActivityDetails")
	}

	@NSManaged
	public var activityProtocol: String
	@NSManaged
	public var nftID: String?
	@NSManaged
	public var poolID: String
	@NSManaged
	public var tokens: Set<CDActivityDetailsToken>
}

// MARK: Generated accessors for tokens

extension CDInvestmentActivityDetails {
	@objc(addTokensObject:)
	@NSManaged
	public func addToTokens(_ value: CDActivityDetailsToken)

	@objc(removeTokensObject:)
	@NSManaged
	public func removeFromTokens(_ value: CDActivityDetailsToken)

	@objc(addTokens:)
	@NSManaged
	public func addToTokens(_ values: NSSet)

	@objc(removeTokens:)
	@NSManaged
	public func removeFromTokens(_ values: NSSet)
}
