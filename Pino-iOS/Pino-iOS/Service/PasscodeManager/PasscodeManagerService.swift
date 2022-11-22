//
//  PasscodeManagerService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/14/22.
//

public struct PasscodeManager {

    // MARK: Public Properties

    public let keychainHelper: KeychainWrapper!

    // MARK: Private Properties

    private enum StorageKeys: String {
        case passcodeStorage
    }

    // MARK: Public Functions

    public func store(_ passcode: String) -> Bool {
        keychainHelper.set(passcode, forKey: PasscodeManager.StorageKeys.passcodeStorage.rawValue, withAccess: nil)
    }

    public func retrievePasscode() -> String? {
        keychainHelper.get(PasscodeManager.StorageKeys.passcodeStorage.rawValue)
    }
    
    public func resetPasscode() -> Bool {
        keychainHelper.delete(PasscodeManager.StorageKeys.passcodeStorage.rawValue)
    }
    
    
}
