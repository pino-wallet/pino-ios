//
//  CoreDataStack.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 4/11/23.
//

import CoreData

class CoreDataStack {
	// MARK: - Public Properties

	public lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
	public static var pinoSharedStack = CoreDataStack(modelName: "Pino_iOS")

	// MARK: - Private Properties

	private let modelName: String

	private lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

	// MARK: - Initializers

	init(modelName: String) {
		self.modelName = modelName
	}

	// MARK: - Public Properties

	public func saveContext() {
		guard managedContext.hasChanges else { return }
		do {
			try managedContext.save()
		} catch let error as NSError {
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
	}
}
