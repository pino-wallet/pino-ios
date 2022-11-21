//
//  VerifyPassVM.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

struct VerifyPassVM: PasscodeManagerPages {
    var title = "Retype passcode"
    var description = "This passcode is for maximizing wallet security. It cannot be used to recover it."
    var password = ""
    var finishPassCreation: () -> Void
    let keychainHelper = PasscodeManager(keychainHelper: KeychainSwift())

    mutating func passInserted(passChar: String) {
        guard password.count < passDigitsCount else { return }
        password.append(passChar)
        if password.count == 6 {
            if let createdPasscode = keychainHelper.retrievePasscode() {
                // pass storation succeeds
                if createdPasscode == password {
                    finishPassCreation()
                } else {
                    // This case is almost impossibele -> Fatal Error
                }
            } else {
                // pass retrival failed
                // Probably the app should crash Or return user back to prev page to create again

            }
        }
    }
}
