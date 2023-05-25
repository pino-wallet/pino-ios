//
//  AssetProtocol.swift
//  Pino-iOS
//
//  Created by Sobhan Eskandari on 3/29/23.
//

import Foundation

public protocol AssetProtocol {
	var id: String { get }
	var amount: String { get }
	var isVerified: Bool { get }
	var detail: Detail? { get }
}
