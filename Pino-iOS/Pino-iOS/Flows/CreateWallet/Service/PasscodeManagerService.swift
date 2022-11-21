//
//  PasscodeManagerService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/14/22.
//

public struct PasscodeManager {
    // MARK: Private Properties

    let keychainHelper: KeychainWrapper!

    private enum StorageKeys: String {
        case passcodeStorage
    }

    func store(passcode: String) -> Bool {
        keychainHelper.set(passcode, forKey: PasscodeManager.StorageKeys.passcodeStorage.rawValue, withAccess: nil)
    }

    func retrievePasscode() -> String? {
        keychainHelper.get(PasscodeManager.StorageKeys.passcodeStorage.rawValue)
    }
}
