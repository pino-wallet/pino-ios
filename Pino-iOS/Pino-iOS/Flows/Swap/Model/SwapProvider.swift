//
//  SwapProvider.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/4/23.
//

import Foundation

struct SwapProvider {
	// MARK: - Public Properties

	public var name: String
	public var image: String

	// MARK: - Initializers

	private init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}

extension SwapProvider {
	// MARK: - Public Properties

	public static var oneInch = SwapProvider(name: "1inch", image: "1inch")
}
