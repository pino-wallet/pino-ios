//
//  UserDefaultsManager.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 1/31/24.
//

import Foundation

struct UserDefaultsManager {
    
    private static let notifSuit = "group.id.notif.service"
    
	public static let isUserLoggedIn = Manager<Bool>(userDefaultKey: .isLogin)
	public static let isDevModeUser = Manager<Bool>(userDefaultKey: .isInDevMode)
	public static let biometricCount = Manager<Int>(userDefaultKey: .showBiometricCounts)
	public static let recentAddUser = Manager<[RecentAddressModel]>(userDefaultKey: .recentSentAddresses)
	public static let hasShowNotifPageUser = Manager<Bool>(userDefaultKey: .hasShownNotifPage)
	public static let securityModesUser = Manager<[String]>(userDefaultKey: .securityModes)
	public static let lockMethodType = Manager<String>(userDefaultKey: .lockMethodType)
	public static let fcmToken = Manager<String>(userDefaultKey: .fcmToken)
	public static let gasLimits = Manager<GasLimitsModel>(userDefaultKey: .gasLimits)
	public static let syncFinishTime = Manager<Date>(userDefaultKey: .syncFinishTime)
	public static let allowNotif = Manager<Bool>(userDefaultKey: .allowNotif)
    
    // Notif Suit
    public static let allowActivityNotif = Manager<Bool>(userDefaultKey: .activityNotif, suit: notifSuit)
    public static let allowPinoUpdateNotif = Manager<Bool>(userDefaultKey: .pinoUpdateNotif, suit: notifSuit)
}

extension UserDefaultsManager {
	class Manager<T: Codable> {
		// MARK: - Private Properties

        private var userDefaults: UserDefaults
		private var userDefaultKey: GlobalUserDefaultsKeys

		// MARK: - Initializers

		fileprivate init(userDefaultKey: GlobalUserDefaultsKeys) {
			self.userDefaultKey = userDefaultKey
            self.userDefaults = UserDefaults.standard
		}
        
        fileprivate init(userDefaultKey: GlobalUserDefaultsKeys, suit: String) {
            self.userDefaultKey = userDefaultKey
            self.userDefaults = .init(suiteName: suit)!
        }

		// MARK: - Private Methods

		private func encodeValue(value: T) -> Data {
			let encoder = JSONEncoder()
			do {
				let result = try encoder.encode(value)
				return result
			} catch {
				fatalError("cant encode recent address list")
			}
		}

		private func decodeValue(value: Data) -> T {
			let decoder = JSONDecoder()
			do {
				let result = try decoder.decode(T.self, from: value)
				return result
			} catch {
				fatalError("cant decode recent address list")
			}
		}

		// MARK: - Public Methods

		public func setValue(value: T) {
			let encodedValue = encodeValue(value: value)
			userDefaults.set(encodedValue, forKey: userDefaultKey.key)
		}

		public func getValue() -> T? {
			guard let defaultValue = userDefaults.value(forKey: userDefaultKey.key) as? Data else {
				return nil
			}
			return decodeValue(value: defaultValue)
		}

		public func removeValuesForKey() {
			userDefaults.removeObject(forKey: userDefaultKey.key)
		}

		public func registerDefault(value: T) {
			let encodedDefaults = encodeValue(value: value)
			userDefaults.register(defaults: [userDefaultKey.key: encodedDefaults])
		}
	}
}

