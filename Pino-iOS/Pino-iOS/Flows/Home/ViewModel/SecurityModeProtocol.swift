//
//  SecurityModeProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/11/23.
//

protocol SecurityModeProtocol {
	var securityMode: Bool { get set }
	var securityText: String { get }
	mutating func enableSecurityMode()
	mutating func disableSecurityMode()
}

extension SecurityModeProtocol {
	var securityText: String { "••••••" }
}
