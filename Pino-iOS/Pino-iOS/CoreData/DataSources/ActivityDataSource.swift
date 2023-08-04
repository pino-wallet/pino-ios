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
    private var coreDataActivities = [CoreDataActivityParent]()
    
    
    // MARK: - Initializers
    init() {
        fetchEntities()
    }
    
    // MARK: - Internal Properties
    
    internal mutating func fetchEntities() {
        let activitiesFetch: NSFetchRequest<CoreDataActivityParent> = CoreDataActivityParent.fetchRequest()
        do {
            let result = try managedContext.fetch(activitiesFetch)
            coreDataActivities = result
        } catch let error as NSError {
            fatalError("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    // MARK: - Public Properties
    
    public func getAll() -> [CoreDataActivityParent] {
        coreDataActivities
    }
    
    public func get(byId id: String) -> CoreDataActivityParent? {
        coreDataActivities.first(where: {$0.txHash == id})
    }
    
    public mutating func save(_ activity: CoreDataActivityParent) {
        if let index = coreDataActivities.firstIndex(where: {$0.txHash == activity.txHash}) {
            coreDataActivities[index] = activity
        } else {
            coreDataActivities.append(activity)
        }
        coreDataStack.saveContext()
    }
    
    public mutating func delete(_ activity: CoreDataActivityParent) {
        coreDataActivities.removeAll(where: {$0.txHash == activity.txHash})
        managedContext.delete(activity)
        coreDataStack.saveContext()
    }
    
    public mutating func deleteByID(_ id: String) {
        if let deletingActivity = coreDataActivities.first(where: {$0.txHash == id}) {
            coreDataActivities.removeAll(where: {$0.txHash == id})
            managedContext.delete(deletingActivity)
            coreDataStack.saveContext()
        }
    }
    
    public func filter(_ predicate: (CoreDataActivityParent) -> Bool) -> [CoreDataActivityParent] {
        coreDataActivities.filter(predicate)
    }
    
    public func sort(by sorter: (CoreDataActivityParent, CoreDataActivityParent) -> Bool) -> [CoreDataActivityParent] {
        coreDataActivities.sorted(by: sorter)
    }
    
    
}
