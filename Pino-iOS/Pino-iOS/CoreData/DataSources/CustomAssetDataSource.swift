//
//  CustomAssetDataSource.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/7/23.
//

import CoreData
import Foundation

struct CustomAssetDataSource: DataSourceProtocol {
	// MARK: - Private Properties

	private var customAssets = [CustomAsset]()

	// MARK: - Initializers

	init() {
		fetchEntities()
	}

	// MARK: - Internal Methods

	internal mutating func fetchEntities() {
		let customAssetsFetch: NSFetchRequest<CustomAsset> = CustomAsset.fetchRequest()
		do {
			let results = try managedContext.fetch(customAssetsFetch)
			customAssets = results
		} catch let error as NSError {
			fatalError("Fetch error: \(error) description: \(error.userInfo)")
		}
	}

	// MARK: - Public Methods

	public mutating func getAll() -> [CustomAsset] {
		fetchEntities()
		return customAssets
	}

	public func getBy(id: String) -> CustomAsset? {
		customAssets.first(where: { $0.id.lowercased() == id.lowercased() })
	}

	public func checkForAlreadyExist(accountAddress: String, id: String) -> Bool {
		let userCustomTokens = customAssets.filter { $0.accountAddress.lowercased() == accountAddress.lowercased() }
		return userCustomTokens.contains { $0.id.lowercased() == id.lowercased() }
	}

	public mutating func save(_ asset: CustomAsset) {
		if let index = customAssets.firstIndex(where: { $0.id.lowercased() == asset.id.lowercased() }) {
			customAssets[index] = asset
		} else {
			customAssets.append(asset)
		}
		coreDataStack.saveContext()
	}

	public mutating func delete(_ asset: CustomAsset) {
		customAssets.removeAll(where: { $0.id.lowercased() == asset.id.lowercased() })
		managedContext.delete(asset)
		coreDataStack.saveContext()
	}

	public func filter(_ predicate: (CustomAsset) -> Bool) -> [CustomAsset] {
		customAssets.filter(predicate)
	}

	public func sort(by sorter: (CustomAsset, CustomAsset) -> Bool) -> [CustomAsset] {
		customAssets.sorted(by: sorter)
	}
}
