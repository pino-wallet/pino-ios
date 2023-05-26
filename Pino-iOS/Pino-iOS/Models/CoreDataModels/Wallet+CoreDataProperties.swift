//
//  Wallet+CoreDataProperties.swift
//  
//
//  Created by Sobhan Eskandari on 5/26/23.
//
//

import Foundation
import CoreData


extension Wallet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wallet> {
        return NSFetchRequest<Wallet>(entityName: "Wallet")
    }

    @NSManaged public var isSelected: Bool
    @NSManaged public var lastDrivedIndex: Int32
    @NSManaged public var type: Int32
    @NSManaged public var accounts: NSSet?

}

// MARK: Generated accessors for accounts
extension Wallet {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: WalletAccount)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: WalletAccount)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

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
