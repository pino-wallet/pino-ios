//
//  SwapProtocolModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import Foundation

struct DexSystemModel: DexSystemModelProtocol, Equatable {
	// MARK: - Public Properties

	public var name: String
	public var image: String
	public var description: String
	public var type: String

	// MARK: - Initializers

	private init(name: String, image: String, description: String, type: String) {
		self.name = name
		self.image = image
		self.description = description
		self.type = type
	}
}

extension DexSystemModel {
	public static var aave = DexSystemModel(
		name: "Aave",
		image: "aave",
		description: "aave.com",
		type: "aave"
	)
	public static var compound = DexSystemModel(
		name: "Compound",
		image: "compound",
		description: "compound.finance",
		type: "compound"
	)
}
