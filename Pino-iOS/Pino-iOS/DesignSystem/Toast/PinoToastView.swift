//
//  ToastView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

public class PinoToastView: UIView {
	// MARK: - Private Properties

	private let toastStackView = UIStackView()
	private let toastLabel = UILabel()
	private let toastImage = UIImageView()
	private var isShowingToast = false

	// MARK: - Public Properties

	public var alignment: Alignment

	public var message: String {
		didSet {
			toastLabel.text = message
		}
	}

	public var image: UIImage? {
		didSet {
			if let image {
				toastImage.image = image
			}
		}
	}

	public var style: Style {
		didSet {
			updateStyle(with: style)
		}
	}

	// MARK: - Initializers

	init(message: String = "", image: UIImage? = nil, style: Style, alignment: Alignment = .bottom) {
		self.alignment = alignment
		self.message = message
		self.image = image
		self.style = style
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupConstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Public Methods

	public func showToast() {
		guard let superView = superview else { fatalError("Toast view has not been added to any view") }
		if !isShowingToast {
			isShowingToast = true
			UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut) { [weak self] in
				guard let self else { return }
				switch self.alignment {
				case .top:
					self.frame.origin = CGPoint(x: self.frame.origin.x, y: 80)
				case .bottom:
					self.frame.origin = CGPoint(x: self.frame.origin.x, y: superView.frame.height - 120)
				}
			} completion: { _ in
				UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut) { [weak self] in
					guard let self else { return }
					switch self.alignment {
					case .top:
						self.frame.origin = CGPoint(x: self.frame.origin.x, y: -28)
					case .bottom:
						self.frame.origin = CGPoint(x: self.frame.origin.x, y: superView.frame.height)
					}
				} completion: { _ in
					self.isShowingToast = false
				}
			}
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(toastStackView)
		toastStackView.addArrangedSubview(toastImage)
		toastStackView.addArrangedSubview(toastLabel)
	}

	private func setupStyle() {
		toastLabel.text = message
		toastImage.image = image
		toastLabel.font = .PinoStyle.semiboldFootnote
		layer.cornerRadius = 14

		updateStyle(with: style)
	}

	private func updateStyle(with style: Style) {
		toastLabel.textColor = style.tintColor
		toastImage.tintColor = style.tintColor
		backgroundColor = style.backgroundColor

		if style.hasShadow {
			layer.shadowColor = UIColor.Pino.black.cgColor
			layer.shadowOpacity = 0.08
			layer.shadowOffset = CGSize(width: 2, height: 4)
			layer.shadowRadius = 4
		} else {
			layer.shadowOpacity = 0
		}
	}

	private func setupConstraint() {
		pin(
			.fixedHeight(28)
		)
		toastStackView.pin(
			.centerY,
			.horizontalEdges(padding: 12)
		)
	}

	public enum Alignment {
		case top
		case bottom
	}
}
