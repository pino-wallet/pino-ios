//
//  SecurityModeProtocol.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/11/23.
//

protocol SecurityModeProtocol {
	var securityMode: Bool { get set }
	var securityText: String { get }
	func switchSecurityMode(_ isOn: Bool)
}

extension SecurityModeProtocol {
	var securityText: String { "••••••" }
}
