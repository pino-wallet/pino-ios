//
//  WalletAccountType+CoreDataProperties.swift
//
//
//  Created by Sobhan Eskandari on 5/10/23.
//
//

import CoreData
import Foundation

extension WalletAccountType {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<WalletAccountType> {
		NSFetchRequest<WalletAccountType>(entityName: "WalletAccountType")
	}

	@NSManaged
	public var source: Int32
}

extension WalletAccountType {
    var accountSource: Account.AccountSource {
        // To get a State enum from stateValue, initialize the
        // State type from the Int32 value stateValue
        get {
            return Account.AccountSource(rawValue: self.source)!
        }

        // newValue will be of type State, thus rawValue will
        // be an Int32 value that can be saved in Core Data
        set {
            self.source = newValue.rawValue
        }
    }
}
