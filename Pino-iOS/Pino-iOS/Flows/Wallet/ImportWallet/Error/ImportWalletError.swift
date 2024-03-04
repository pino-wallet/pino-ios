//
//  ImportWalletError.swift
//  Pino-iOS
//
//  Created by MohammadHossein Ghadamyari on 2022-12-01.
//

import Foundation

enum ImportValidationError: Error {
	case invalidSecretPhrase
	case invalidPrivateKey
}
