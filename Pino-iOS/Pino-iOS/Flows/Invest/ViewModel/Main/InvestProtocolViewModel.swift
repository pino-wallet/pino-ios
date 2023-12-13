//
//  InvestProtocolViewModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 8/14/23.
//

import Foundation

public enum InvestProtocolViewModel: String, DexSystemModelProtocol {
	case compound = "compound"
	case aave = "aave"
	case maker = "maker"
	case lido = "lido"

	public var name: String {
		switch self {
		case .compound:
			return "Compound"
		case .aave:
			return "Aave"
		case .maker:
			return "Maker"
		case .lido:
			return "Lido"
		}
	}

	public var image: String {
		switch self {
		case .compound:
			return "compound"
		case .aave:
			return "aave"
		case .maker:
			return "maker"
		case .lido:
			return "lido"
		}
	}

	public var description: String {
		switch self {
		case .compound:
			return "compound.finance"
		case .aave:
			return "aave.com"
		case .maker:
			return ""
		case .lido:
			return ""
		}
	}

	public var version: String {
		switch self {
		case .compound:
			return "V2"
		case .aave:
			return "V3"
		case .maker:
			return ""
		case .lido:
			return ""
		}
	}

	public var type: String {
		rawValue
	}

	public init(type: String) {
		self.init(rawValue: type)!
	}
}
