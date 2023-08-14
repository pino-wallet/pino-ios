//
//  CircleMarker.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/6/23.
//

import DGCharts
import CoreGraphics
import Foundation
import UIKit

class CircleMarker: MarkerImage {
	@objc
	var color: UIColor
	@objc
	var radius: CGFloat = 7

	@objc
	public init(color: UIColor) {
		self.color = .Pino.clear
		super.init()
		self.image = UIImage(named: "circle_marker")
	}

	override func draw(context: CGContext, point: CGPoint) {
		guard let image = image else { return }

		let rect = CGRect(
			x: point.x - radius,
			y: point.y - radius,
			width: radius * 2,
			height: radius * 2
		)

		UIGraphicsPushContext(context)
		image.draw(in: rect)
		UIGraphicsPopContext()
	}
}
