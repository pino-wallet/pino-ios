//
//  Wallet+CoreDataProperties.swift
//
//
//  Created by Amir hossein kazemi seresht on 5/27/23.
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
	public var isSelected: Bool
	@NSManaged
	public var lastDrivedIndex: Int32
	@NSManaged
	public var type: Int32
	@NSManaged
	public var accounts: NSSet?
}

// MARK: Generated accessors for accounts

extension Wallet {
	@objc(addAccountsObject:)
	@NSManaged
	public func addToAccounts(_ value: WalletAccount)

	@objc(removeAccountsObject:)
	@NSManaged
	public func removeFromAccounts(_ value: WalletAccount)

	@objc(addAccounts:)
	@NSManaged
	public func addToAccounts(_ values: NSSet)

	@objc(removeAccounts:)
	@NSManaged
	public func removeFromAccounts(_ values: NSSet)
}
