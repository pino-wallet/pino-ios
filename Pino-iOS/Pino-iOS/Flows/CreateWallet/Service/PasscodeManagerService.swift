//
//  PasscodeManagerService.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/14/22.
//

protocol KeychainHelperProtocol {
    get(key: String) -> String? {}
    @discardableResult 
    open func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool
}
public struct PasscodeManager {
	// MARK: Private Properties

    private let keychainHelper: KeychainHelperProtocol!

	private static enum StorageKeys: String {
        case passcodeStorage
    }

    func store(passcode: String) -> Bool {
        keychainHelper.set(passcode, forKey: PasscodeManager.StorageKeys.passcodeStorage)
    }

    func retrievePasscode() -> String? {
        keychainHelper.get(key: PasscodeManager.StorageKeys.passcodeStorage)
    }
}
