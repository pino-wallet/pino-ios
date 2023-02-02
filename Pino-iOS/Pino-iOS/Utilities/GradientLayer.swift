//
//  GradientLayer.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 1/2/23.
//

import UIKit

class GradientLayer: CAGradientLayer {
	// MARK: - Initializers

	init(frame: CGRect, style: Style) {
		super.init()
		self.frame = frame
		self.colors = style.colors
		self.locations = style.locations
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension GradientLayer {
	struct Style {
		// MARK: - Public Properties

		public let colors: [CGColor]
		public let locations: [NSNumber]

		// Custom Styles
		public static let homeBackground = Style(
			colors: [UIColor.Pino.secondaryBackground.cgColor, UIColor.Pino.background.cgColor],
			locations: [0.4, 0.45]
		)
		public static let headerBackground = Style(
			colors: [UIColor.Pino.secondaryBackground.cgColor, UIColor.Pino.background.cgColor],
			locations: [0.2, 0.5]
		)
	}
}
