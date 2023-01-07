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
	private var superView: UIView!

	// MARK: - Public Properties

	public var alignment: Alignment

	public var message: String? {
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

	init(message: String?, image: UIImage? = nil, style: Style, alignment: Alignment = .bottom) {
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
		if !isShowingToast {
			isShowingToast = true
			setupSuperView()
			switch alignment {
			case .top:
				animateToastView(
					originY: 10,
					destinationY: 32,
					delay: 1.2,
					verticalConstraint: .top(to: superView.layoutMarginsGuide, padding: 32),
					isFade: true
				)
			case .bottom:
				animateToastView(
					originY: superView.frame.height,
					destinationY: superView.frame.height - 60,
					delay: 2,
					verticalConstraint: .bottom(to: superView.layoutMarginsGuide, padding: 60)
				)
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
		toastStackView.pin(
			.verticalEdges(padding: 7),
			.horizontalEdges(padding: 14)
		)
	}

	private func setupSuperView() {
		let currentWindow = UIApplication
			.shared
			.connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.first(where: { $0 is UIWindowScene })
			.flatMap { $0 as? UIWindowScene }?.windows
			.first(where: \.isKeyWindow)
		guard let superView = currentWindow?.rootViewController?.view
		else { fatalError("Toast view has not been added to any view") }
		superView.addSubview(self)
		self.superView = superView
	}

	private func animateToastView(
		originY: CGFloat,
		destinationY: CGFloat,
		delay: Double,
		verticalConstraint: Constraint,
		isFade: Bool = false
	) {
		alpha = isFade ? 0 : 1
		pin(.centerX, verticalConstraint)
		frame.origin = CGPoint(x: frame.origin.x, y: originY)
		updateCornerRadius()
		UIView.animate(
			withDuration: 0.9,
			delay: 0,
			usingSpringWithDamping: 0.7,
			initialSpringVelocity: 0.3
		) { [weak self] in
			guard let self else { return }
			self.alpha = 1
			self.frame.origin = CGPoint(x: self.frame.origin.x, y: destinationY)
		} completion: { _ in
			UIView.animate(
				withDuration: 0.8,
				delay: delay,
				usingSpringWithDamping: 0.7,
				initialSpringVelocity: 0.3
			) { [weak self] in
				guard let self else { return }
				self.alpha = isFade ? 0 : 1
				self.frame.origin = CGPoint(x: self.frame.origin.x, y: originY + self.frame.height)
			} completion: { _ in
				self.isShowingToast = false
				self.removeFromSuperview()
			}
		}
	}

	private func updateCornerRadius() {
		layoutIfNeeded()
		layer.cornerRadius = frame.height / 2
	}

	public enum Alignment {
		case top
		case bottom
	}
}
