//
//  WalletAccount+CoreDataProperties.swift
//
//
//  Created by Sobhan Eskandari on 5/13/23.
//
//

import CoreData
import Foundation

extension WalletAccount {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<WalletAccount> {
		NSFetchRequest<WalletAccount>(entityName: "WalletAccount")
	}

	@NSManaged
	public var avatarColor: String
	@NSManaged
	public var avatarIcon: String
	@NSManaged
	public var derivationPath: String?
	@NSManaged
	public var eip55Address: String
	@NSManaged
	public var isSelected: Bool
	@NSManaged
	public var name: String
	@NSManaged
	public var publicKey: Data
	@NSManaged
	public var wallet: Wallet
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
			WalletType(rawValue: type)!
		}
		// newValue will be of type State, thus rawValue will
		// be an Int32 value that can be saved in Core Data
		set {
			type = newValue.rawValue
		}
	}
}
