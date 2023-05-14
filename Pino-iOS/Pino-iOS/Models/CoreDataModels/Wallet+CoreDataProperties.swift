//
//  Wallet+CoreDataProperties.swift
//
//
//  Created by Sobhan Eskandari on 5/13/23.
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
	public var lastDrivedIndex: Int32
	@NSManaged
	public var type: Int32
	@NSManaged
	public var isSelected: Bool
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

extension Wallet {
	public enum WalletType: Int32, Codable {
		case hdWallet = 0
		case nonHDWallet = 1
	}

	var walletType: WalletType {
		// To get a State enum from stateValue, initialize the
		// State type from the Int32 value stateValue
		get {
			WalletType(rawValue: self.type)!
		}

		// newValue will be of type State, thus rawValue will
		// be an Int32 value that can be saved in Core Data
		set {
			self.type = newValue.rawValue
		}
	}
}
