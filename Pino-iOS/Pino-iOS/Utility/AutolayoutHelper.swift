//
//  AutolayoutHelper.swift
//  Pino-iOS
//  Source of the Article : https://www.mikegopsill.com/autolayout-dsl/
//  Repo address of helper class : https://github.com/mgopsill/MGLayout/
//  Created by MohammadHossein Ghadamyari on 2022-11-10.
//

import UIKit

// MARK: - Constraint
// swiftlint:disable all
enum Constraint {
	case relative(NSLayoutConstraint.Attribute, CGFloat, to: Anchorable? = nil, NSLayoutConstraint.Attribute? = nil)
	case fixed(NSLayoutConstraint.Attribute, CGFloat)
	case multiple([Constraint])
}

extension Constraint {
	static let top: Constraint = .top()
	static let bottom: Constraint = .bottom()
	static let trailing: Constraint = .trailing()
	static let leading: Constraint = .leading()
	static let width: Constraint = .width()
	static let height: Constraint = .height()
	static let centerX: Constraint = .centerX()
	static let centerY: Constraint = .centerY()
	static let verticalEdges: Constraint = .verticalEdges()
	static let horizontalEdges: Constraint = .horizontalEdges()
	static let allEdges: Constraint = .allEdges()

	static func top(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.top, padding, to: anchors)
	}

	static func bottom(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.bottom, -padding, to: anchors)
	}

	static func trailing(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.trailing, -padding, to: anchors)
	}

	static func leading(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.leading, padding, to: anchors)
	}

	static func top(
		to anchors: Anchorable? = nil,
		_ toAttribute: NSLayoutConstraint.Attribute? = nil,
		padding: CGFloat = 0
	) -> Constraint {
		.relative(.top, padding, to: anchors, toAttribute)
	}

	static func bottom(
		to anchors: Anchorable? = nil,
		_ toAttribute: NSLayoutConstraint.Attribute? = nil,
		padding: CGFloat = 0
	) -> Constraint {
		.relative(.bottom, -padding, to: anchors, toAttribute)
	}

	static func trailing(
		to anchors: Anchorable? = nil,
		_ toAttribute: NSLayoutConstraint.Attribute? = nil,
		padding: CGFloat = 0
	) -> Constraint {
		.relative(.trailing, -padding, to: anchors, toAttribute)
	}

	static func leading(
		to anchors: Anchorable? = nil,
		_ toAttribute: NSLayoutConstraint.Attribute? = nil,
		padding: CGFloat = 0
	) -> Constraint {
		.relative(.leading, padding, to: anchors, toAttribute)
	}

	static func fixedWidth(_ constant: CGFloat) -> Constraint {
		.fixed(.width, constant)
	}

	static func width(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.width, padding, to: anchors)
	}

	static func fixedHeight(_ constant: CGFloat) -> Constraint {
		.fixed(.height, constant)
	}

	static func height(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.height, padding, to: anchors)
	}

	static func centerX(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.centerX, padding, to: anchors)
	}

	static func centerY(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.relative(.centerY, padding, to: anchors)
	}

	static func verticalEdges(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.multiple([.top(to: anchors, padding: padding), .bottom(to: anchors, padding: padding)])
	}

	static func horizontalEdges(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.multiple([.leading(to: anchors, padding: padding), .trailing(to: anchors, padding: padding)])
	}

	static func allEdges(to anchors: Anchorable? = nil, padding: CGFloat = 0) -> Constraint {
		.multiple([.horizontalEdges(to: anchors, padding: padding), .verticalEdges(to: anchors, padding: padding)])
	}
}

extension NSLayoutConstraint {
	convenience init(
		item: Any,
		attribute: Attribute,
		toItem: Any? = nil,
		toAttribute: Attribute = .notAnAttribute,
		constant: CGFloat
	) {
		self.init(
			item: item,
			attribute: attribute,
			relatedBy: .equal,
			toItem: toItem,
			attribute: toAttribute,
			multiplier: 1,
			constant: constant
		)
	}
}

extension UIView {
	@discardableResult
	func place(on view: UIView) -> UIView {
		view.addSubview(self)
		translatesAutoresizingMaskIntoConstraints = false
		return self
	}

	@discardableResult
	func pin(_ constraints: Constraint...) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		apply(constraints)
		return self
	}

	private func apply(_ constraints: [Constraint]) {
		for constraint in constraints {
			switch constraint {
			case let .relative(attribute, constant, toItem, toAttribute):
				NSLayoutConstraint(
					item: self,
					attribute: attribute,
					toItem: toItem ?? superview!,
					toAttribute: toAttribute ?? attribute,
					constant: constant
				).isActive = true
			case let .fixed(attribute, constant):
				NSLayoutConstraint(
					item: self,
					attribute: attribute,
					constant: constant
				).isActive = true
			case let .multiple(constraints):
				apply(constraints)
			}
		}
	}
}

// MARK: - Anchorable

protocol Anchorable {
	var leadingAnchor: NSLayoutXAxisAnchor { get }
	var trailingAnchor: NSLayoutXAxisAnchor { get }
	var leftAnchor: NSLayoutXAxisAnchor { get }
	var rightAnchor: NSLayoutXAxisAnchor { get }
	var topAnchor: NSLayoutYAxisAnchor { get }
	var bottomAnchor: NSLayoutYAxisAnchor { get }
	var widthAnchor: NSLayoutDimension { get }
	var heightAnchor: NSLayoutDimension { get }
	var centerXAnchor: NSLayoutXAxisAnchor { get }
	var centerYAnchor: NSLayoutYAxisAnchor { get }
}

// MARK: - UIView + Anchorable

extension UIView: Anchorable {}

// MARK: - UILayoutGuide + Anchorable

extension UILayoutGuide: Anchorable {
	var firstBaselineAnchor: NSLayoutYAxisAnchor {
		preconditionFailure("UILayoutGuide does not support firstBaselineAnchor")
	}

	var lastBaselineAnchor: NSLayoutYAxisAnchor {
		preconditionFailure("UILayoutGuide does not support firstBaselineAnchor")
	}
}
