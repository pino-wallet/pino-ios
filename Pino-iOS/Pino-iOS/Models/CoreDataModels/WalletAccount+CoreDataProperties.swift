//
//  WalletAccount+CoreDataProperties.swift
//  
//
//  Created by Sobhan Eskandari on 5/13/23.
//
//

import Foundation
import CoreData


extension WalletAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletAccount> {
        return NSFetchRequest<WalletAccount>(entityName: "WalletAccount")
    }

    @NSManaged public var avatarColor: String
    @NSManaged public var avatarIcon: String
    @NSManaged public var derivationPath: String?
    @NSManaged public var eip55Address: String
    @NSManaged public var isSelected: Bool
    @NSManaged public var name: String
    @NSManaged public var publicKey: Data
    @NSManaged public var wallet: Wallet

}
