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
	public var publicKey: String
	@NSManaged
	public var wallet: Wallet
	@NSManaged
	public var lastBalance: String
	@NSManaged
	public var selectedAssets: NSSet
	@NSManaged
	public var lastETHBalance: String?
	@NSManaged
	public var isPositionEnabled: Bool
	@NSManaged
	public var hasDefaultAssets: Bool
}
