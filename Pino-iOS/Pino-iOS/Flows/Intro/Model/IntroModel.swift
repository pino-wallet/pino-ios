//
//  IntroModel.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/20/22.
//

import UIKit

public struct IntroModel {
	// MARK: Public Properties

	public let image: UIImage
	public let title: String
	public let description: String

	// MARK: Initializers

	init(image: UIImage, title: String, description: String) {
		self.image = image
		self.title = title
		self.description = description
	}
}
