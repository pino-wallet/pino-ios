//
//  ActivityDataSource.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/4/23.
//

import CoreData
import Foundation

struct ActivityDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var activities = [CDActivityParent]()

	// MARK: - Initializers

	init() {
		fetchEntities()
	}

	// MARK: - Internal Properties

	internal mutating func fetchEntities() {
		let activitiesFetch: NSFetchRequest<CDActivityParent> = CDActivityParent.fetchRequest()
		do {
			let result = try managedContext.fetch(activitiesFetch)
			activities = result
		} catch let error as NSError {
			fatalError("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Properties

	public mutating func getAll() -> [CDActivityParent] {
		fetchEntities()
		return activities
	}

	public func get(byId id: String) -> CDActivityParent? {
		activities.first(where: { $0.txHash.lowercased() == id.lowercased() })
	}

	public mutating func save(_ activity: CDActivityParent) {
		if let index = activities.firstIndex(where: { $0.txHash.lowercased() == activity.txHash.lowercased() }) {
			activities[index] = activity
		} else {
			activities.append(activity)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ activity: CDActivityParent) {
		activities.removeAll(where: { $0.txHash.lowercased() == activity.txHash.lowercased() })
		managedContext.delete(activity)
		coreDataStack.saveContext()
	}

	// WARNING: -> This function is for TESTING purpose
	public mutating func deleteAllActivities() {
		activities.forEach { act in
			managedContext.delete(act)
		}
		activities.removeAll()
		coreDataStack.saveContext()
	}

	public mutating func deleteByID(_ id: String) {
		if let deletingActivity = activities.first(where: { $0.txHash.lowercased() == id.lowercased() }) {
			activities.removeAll(where: { $0.txHash.lowercased() == id.lowercased() })
			managedContext.delete(deletingActivity)
			coreDataStack.saveContext()
		}
	}

	public func filter(_ predicate: (CDActivityParent) -> Bool) -> [CDActivityParent] {
		activities.filter(predicate)
	}

	public func sort(by sorter: (CDActivityParent, CDActivityParent) -> Bool) -> [CDActivityParent] {
		activities.sorted(by: sorter)
	}

	public func performSpeedUpChanges(txHash: String, newTxHash: String, newGasPrice: String) {
		let updatingIndex = activities.firstIndex(where: { $0.txHash.lowercased() == txHash.lowercased() })
		guard let updatingIndex else {
			return
		}
		activities[updatingIndex].gasPrice = newGasPrice
		activities[updatingIndex].txHash = newTxHash
		activities[updatingIndex].prevTxHash = txHash
		coreDataStack.saveContext()
	}
}
