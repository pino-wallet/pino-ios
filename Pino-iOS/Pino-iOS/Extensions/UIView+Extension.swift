//
//  UIView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 3/4/23.
//

import UIKit

extension UIView {
	private var skeletonContainerName: String {
		"skeletonContainer"
	}

	private var skeletonBorderedName: String {
		"skeletonBordered"
	}

	private var skeletonGradientName: String {
		"skeletonGradient"
	}

	public var isSkeletonable: Bool {
		get { if layer.name == skeletonContainerName {
			return true
		} else {
			return false
		}
		}
		set { if newValue {
			layer.name = skeletonContainerName
		}}
	}

	public var isSkeletonBordered: Bool {
		get { if layer.name == skeletonBorderedName {
			return true
		} else {
			return false
		}
		}
		set { if newValue {
			layer.name = skeletonBorderedName
		}}
	}

	private var skeletonViewName: String {
		"skeletonView"
	}

	private var skeletonBorderedViewName: String {
		"skeletonBordered"
	}

	public var isHiddenInStackView: Bool {
		get {
			isHidden
		}
		set {
			if isHidden != newValue {
				isHidden = newValue
			}
		}
	}

	private func getAllSkeletonViews(view: UIView) -> [UIView] {
		var skeletonViews = [UIView]()
		for subview in view.subviews {
			switch subview {
			case _ where subview.isSkeletonable:
				skeletonViews += [subview]
			case _ where subview.isSkeletonBordered:
				skeletonViews += [subview]
				skeletonViews += getAllSkeletonViews(view: subview)
			default:
				skeletonViews += getAllSkeletonViews(view: subview)
			}
		}
		return skeletonViews
	}

	public func showSkeletonView(backgroundColor: UIColor? = nil, animationColor: UIColor? = nil) {
		let skeletonViews = getAllSkeletonViews(view: self)

		skeletonViews.forEach { skeletonView in

			skeletonView.layoutIfNeeded()

			if skeletonView.isSkeletonBordered {
				let gradientBorderedView = UIView()
				gradientBorderedView.layer.name = skeletonBorderedViewName
				gradientBorderedView.layer.borderWidth = skeletonView.layer.borderWidth
				gradientBorderedView.layer.cornerRadius = skeletonView.layer.cornerRadius
				gradientBorderedView.backgroundColor = .clear
				let gradientBorderLayer = CAGradientLayer()
				gradientBorderLayer.frame = CGRect(origin: CGPoint.zero, size: skeletonView.frame.size)
				gradientBorderLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
				gradientBorderLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
				gradientBorderLayer.colors = [UIColor.Pino.skeleton1.cgColor, UIColor.Pino.skeleton2.cgColor]
				let gradientBorderRenderer =
					UIGraphicsImageRenderer(bounds: CGRect(origin: CGPoint.zero, size: skeletonView.frame.size))
				let gradientBorderImage = gradientBorderRenderer.image { ctx in
					gradientBorderLayer.render(in: ctx.cgContext)
				}
				let gradientBorderColor = UIColor(patternImage: gradientBorderImage)

				gradientBorderedView.layer.borderColor = gradientBorderColor.cgColor
				skeletonView.addSubview(gradientBorderedView)
				skeletonView.bringSubviewToFront(gradientBorderedView)
				skeletonView.layer.borderWidth = 0
				gradientBorderedView.pin(.allEdges(padding: 0))
			} else {
				let gradientLayer = CAGradientLayer()

				gradientLayer.colors = [
					(backgroundColor ?? UIColor.Pino.skeleton2).cgColor,
					(animationColor ?? UIColor.Pino.skeleton1).cgColor,
					(backgroundColor ?? UIColor.Pino.skeleton2).cgColor,
				]

				gradientLayer.locations = [0, 0.5]
				gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
				gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

				gradientLayer
					.transform =
					CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -15.17, tx: 1, ty: 8.09))

				gradientLayer.position = skeletonView.center

				let bounds = UIScreen.main.bounds
				gradientLayer.bounds = bounds
				let backgroundView = UIView()
				let corneredView = UIView()
				skeletonView.addSubview(backgroundView)
				backgroundView.addSubview(corneredView)
				backgroundView.layer.name = skeletonViewName
				backgroundView.pin(.allEdges(padding: 0))
				corneredView.pin(.allEdges(padding: 0))
				backgroundView.backgroundColor = backgroundColor ?? .Pino.white
				corneredView.backgroundColor = backgroundColor ?? .Pino.skeleton2

				if skeletonView.layer.cornerRadius == 0 {
					corneredView.layer.cornerRadius = skeletonView.frame.size.height / 2
				}

				corneredView.clipsToBounds = true
				corneredView.layer.addSublayer(gradientLayer)

				let screenWidth = UIScreen.main.bounds.width

				let animation = CABasicAnimation(keyPath: "transform.translation.x")
				animation.duration = 3
				animation.fromValue = -screenWidth
				animation.toValue = screenWidth
				animation.repeatCount = .infinity
				animation.autoreverses = false
				animation.fillMode = CAMediaTimingFillMode.forwards
				gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
			}
		}
	}

	public func hideSkeletonView() {
		let skeletonViews = getAllSkeletonViews(view: self)

		skeletonViews.forEach { skeletonView in
			skeletonView.subviews.forEach { subview in
				switch subview.layer.name {
				case skeletonViewName:
					subview.removeFromSuperview()
				case skeletonBorderedViewName:
					subview.superview?.layer.borderWidth = subview.layer.borderWidth
					subview.removeFromSuperview()
				case .none:
					return
				case .some:
					return
				}
			}
		}
	}

	public func showGradientSkeletonView(startLocation: NSNumber = 0, endLocation: NSNumber = 0.6) {
		layoutIfNeeded()
		// Prevent to add gradient view twice
		for subview in subviews.filter({ $0.layer.name == skeletonGradientName }) {
			subview.removeFromSuperview()
		}
		// Add loading gradient view
		let gradientLoadingView = UIView()
		gradientLoadingView.layer.name = skeletonGradientName
		let loadingGradientLayer = GradientLayer(
			frame: bounds,
			colors: [.Pino.clear, .Pino.background],
			startPoint: CGPoint(x: 0.5, y: 0.4),
			endPoint: CGPoint(x: 0.5, y: 1)
		)
		loadingGradientLayer.locations = [startLocation, endLocation]
		gradientLoadingView.layer.addSublayer(loadingGradientLayer)
		addSubview(gradientLoadingView)
		// Show all skeletonable ui elements
		showSkeletonView()
	}

	public func hideGradientSkeletonView() {
		for subview in subviews.filter({ $0.layer.name == skeletonGradientName }) {
			subview.removeFromSuperview()
		}
		hideSkeletonView()
	}
}
