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
