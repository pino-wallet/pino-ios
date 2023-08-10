//
//  DataSourceProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 5/8/23.
//

import CoreData

protocol DataSourceProtocol {
	associatedtype CoreDataType

	var coreDataStack: CoreDataStack { get }
	var managedContext: NSManagedObjectContext { get }

	mutating func fetchEntities()
	mutating func getAll() -> [CoreDataType]
	func get(byId id: String) -> CoreDataType?
	mutating func save(_ item: CoreDataType)
	mutating func delete(_ item: CoreDataType)

	func filter(_ predicate: (CoreDataType) -> Bool) -> [CoreDataType]
	func sort(by sorter: (CoreDataType, CoreDataType) -> Bool) -> [CoreDataType]
}

extension DataSourceProtocol {
	var coreDataStack: CoreDataStack {
		CoreDataStack.pinoSharedStack
	}

	var managedContext: NSManagedObjectContext {
		coreDataStack.managedContext
	}
}
