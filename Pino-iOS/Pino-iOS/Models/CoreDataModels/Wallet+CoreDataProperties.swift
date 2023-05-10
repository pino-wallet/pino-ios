//
//  Wallet+CoreDataProperties.swift
//
//
//  Created by Sobhan Eskandari on 5/10/23.
//
//

import CoreData
import Foundation

extension Wallet {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<Wallet> {
		NSFetchRequest<Wallet>(entityName: "Wallet")
	}

	@NSManaged
	public var account: NSSet?
}

// MARK: Generated accessors for account

extension Wallet {
	@objc(addAccountObject:)
	@NSManaged
	public func addToAccount(_ value: WalletAccount)

	@objc(removeAccountObject:)
	@NSManaged
	public func removeFromAccount(_ value: WalletAccount)

	@objc(addAccount:)
	@NSManaged
	public func addToAccount(_ values: NSSet)

	@objc(removeAccount:)
	@NSManaged
	public func removeFromAccount(_ values: NSSet)
}
