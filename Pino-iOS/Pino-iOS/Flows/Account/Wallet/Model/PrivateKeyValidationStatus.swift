//
//  PrivateKeyValidationStatus.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/16/24.
//

import Foundation

public enum PrivateKeyValidationStatus: Equatable {
	case empty
	case validKey
	case invalidKey
	case invalidAccount
}
