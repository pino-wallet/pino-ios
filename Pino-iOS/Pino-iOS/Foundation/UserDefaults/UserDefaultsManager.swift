//
//  UserDefaultsManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/31/24.
//

import Foundation

class UserDefaultsManager {
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private var userDefaultKey: GlobalUserDefaultsKeys
    
    // MARK: - Initializers
    
    init(userDefaultKey: GlobalUserDefaultsKeys) {
        self.userDefaultKey = userDefaultKey
    }
    
    // MARK: - Private Methods
    private func encodeValue<T: Codable>(value: T) -> Data {
        let encoder = JSONEncoder()
        do {
            let result = try encoder.encode(value)
            return result
        } catch {
            fatalError("cant encode recent address list")
        }
    }

    private func decodeValue<T: Decodable>(value: Data) -> T {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: value)
            return result
        } catch {
            fatalError("cant decode recent address list")
        }
    }
    
    // MARK: - Public Methods
    
    public func setValue<T: Codable>(value: T) {
        let encodedValue = encodeValue(value: value)
        userDefaults.set(encodedValue, forKey: userDefaultKey.key)
    }
    
    public func getValue<T: Codable>() -> T? {
        guard let defaultValue = userDefaults.value(forKey: userDefaultKey.key) as? Data else {
            return nil
        }
        return decodeValue(value: defaultValue)
    }
    
    public func removeValuesForKey() {
        userDefaults.removeObject(forKey: userDefaultKey.key)
    }
    
    public func registerDefaults<T: Codable>(defaults: [String:T]) {
        let encodedDefaults = defaults.mapValues { encodeValue(value: $0) }
        userDefaults.register(defaults: encodedDefaults)
    }
    
}
