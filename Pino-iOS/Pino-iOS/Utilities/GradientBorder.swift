//
//  GradientBorder.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/8/23.
//

import UIKit

class GradientBorderView: UIView {
	private var gradientLayer: CAGradientLayer!
	private var shape: CAShapeLayer!

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	private func createGradientBorder(colors: [UIColor]) {
		gradientLayer?.removeFromSuperlayer()

		gradientLayer = CAGradientLayer()
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradientLayer.colors = colors.map { $0.cgColor }
		layer.addSublayer(gradientLayer)

		shape = CAShapeLayer()
		shape.lineWidth = 2.5
		shape.strokeColor = UIColor.black.cgColor
		shape.fillColor = UIColor.clear.cgColor
		shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
		gradientLayer.mask = shape
		gradientLayer.frame = bounds
	}

	// MARK: - Public Methods

	func updateGradientColors(_ colors: [UIColor]) {
		createGradientBorder(colors: colors)
	}
}
