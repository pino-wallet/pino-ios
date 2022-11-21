//
//  KeychainWrapperProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 11/21/22.
//

import Foundation

protocol KeychainWrapper {
    func get(_ key: String) -> String?
    func set(
        _ value: String,
        forKey key: String,
        withAccess access: KeychainSwiftAccessOptions?
    ) -> Bool
}
