//
//  CreatePassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct CreatePassVM: PasscodeManagerPages {
    var title = "Create passcode"
    var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
    var password = ""
    var finishPassCreation: () -> Void
    let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())

    mutating func passInserted(passChar: String) {
        guard password.count < passDigitsCount else { return }
        password.append(passChar)
        if password.count == 6 {
            if keychainHelper.store(passcode: password) {
                // pass storation succeeds
                finishPassCreation()
            } else {
                // pass storation fails
                // In case keychain is disabled We should show a critical Error
            }
        }
    }

    func resetPassword() {
        // User returns from verify screens to edit the passcode so previous passcode
        // Should be removed from keychain and the new one be replaced
    }
}
