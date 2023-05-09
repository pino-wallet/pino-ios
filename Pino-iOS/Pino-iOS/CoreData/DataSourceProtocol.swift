//
//  DataSourceProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import CoreData

protocol DataSourceProtocol {
	associatedtype T

	var coreDataStack: CoreDataStack { get }
	var managedContext: NSManagedObjectContext { get }

	func getAll() -> [T]
	func get(byId id: String) -> T?
	mutating func save(_ item: T)
	mutating func delete(_ item: T)

	func filter(_ predicate: (T) -> Bool) -> [T]
	func sort(by sorter: (T, T) -> Bool) -> [T]
}

extension DataSourceProtocol {
	var coreDataStack: CoreDataStack {
		AppDelegate.sharedAppDelegate.coreDataStack
	}

	var managedContext: NSManagedObjectContext {
		AppDelegate.sharedAppDelegate.coreDataStack.managedContext
	}
}
