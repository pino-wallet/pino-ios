//
//  ChartMarker.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/26/23.
//

import Charts
import Foundation
import UIKit

open class BalloonMarker: MarkerImage {
	@objc
	open var color: UIColor
	@objc
	open var font: UIFont
	@objc
	open var textColor: UIColor
	@objc
	open var insets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)

	fileprivate var label: String?
	fileprivate var labelSize = CGSize()
	fileprivate var paragraphStyle: NSMutableParagraphStyle?
	fileprivate var drawAttributes = [NSAttributedString.Key: Any]()

	@objc
	public init(color: UIColor, font: UIFont, textColor: UIColor) {
		self.color = color
		self.font = font
		self.textColor = textColor

		self.paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
		paragraphStyle?.alignment = .center
		super.init()
	}

	override open func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
		var offset = CGPoint(x: offset.x, y: offset.y + 5)

		if point.x + offset.x <= 10 {
			offset.x = -point.x + labelSize.width
		} else if let chart = chartView,
		          point.x + labelSize.width + offset.x > chart.bounds.size.width {
			offset.x = chart.bounds.size.width - point.x - labelSize.width
		}

		if point.y + offset.y < 30 {
			offset.y = labelSize.height + insets.top + insets.bottom
		} else if let chart = chartView,
		          point.y + labelSize.height + offset.y > chart.bounds.size.height {
			offset.y = chart.bounds.size.height - labelSize.height
		}

		return offset
	}

	override open func draw(context: CGContext, point: CGPoint) {
		guard let label = label else { return }

		let offset = offsetForDrawing(atPoint: point)

		var rect = CGRect(
			origin: CGPoint(
				x: point.x + offset.x,
				y: point.y + offset.y
			),
			size: size
		)
		rect.origin.x -= size.width / 2.0
		rect.origin.y -= size.height
		rect.origin.y -= 10

		context.saveGState()

		context.setFillColor(color.cgColor)

		context.saveGState()
		defer { context.restoreGState() }

		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: [.allCorners],
			cornerRadii: CGSize(width: rect.width / 2, height: rect.width / 2)
		)

		context.addPath(path.cgPath)
		context.closePath()

		context.setFillColor(color.withAlphaComponent(0.8).cgColor)
		context.fillPath()

		rect.origin.y += insets.top + 1

		UIGraphicsPushContext(context)

		label.draw(in: rect, withAttributes: drawAttributes)

		UIGraphicsPopContext()

		context.restoreGState()
	}

	override open func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
		setLabel(String(entry.y))
	}

	@objc
	open func setLabel(_ newLabel: String) {
		label = newLabel.currencyFormatting

		drawAttributes.removeAll()
		drawAttributes[.font] = font
		drawAttributes[.paragraphStyle] = paragraphStyle
		drawAttributes[.foregroundColor] = textColor

		labelSize = label?.size(withAttributes: drawAttributes) ?? CGSize.zero

		size.width = labelSize.width + insets.left + insets.right
		size.height = labelSize.height + insets.top + insets.bottom
	}
}
