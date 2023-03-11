//
//  ToastView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/19/22.
//

import UIKit

public class PinoToastView: UIView, ToastView {
	typealias styleType = Style

	// MARK: - Private Properties

	private let toastStackView = UIStackView()
	private let toastLabel = UILabel()
	private let toastImage = UIImageView()
	private var isShowingToast = false
	private var padding: CGFloat

	// MARK: - Public Properties

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
			updateStyle()
		}
	}

	// MARK: - Initializers

	init(message: String?, image: UIImage? = nil, style: Style, padding: CGFloat = 60) {
		self.message = message
		self.image = image
		self.style = style
		self.padding = padding
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
			if let superView = superView() {
				animateToastView(
					originY: superView.frame.height,
					destinationY: superView.frame.height - padding,
					delay: 2,
					verticalConstraint: .bottom(to: superView.layoutMarginsGuide, padding: padding)
				)
			} else {
				fatalError("Toast view has not been added to any view")
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
		toastStackView.spacing = 4
		updateStyle()
	}

	private func updateStyle() {
		toastLabel.textColor = style.tintColor
		toastImage.tintColor = style.tintColor
		backgroundColor = style.backgroundColor
		toastImage.image = UIImage(named: "info_circle")

		toastImage.isHidden = style.imageIsHidden

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
		toastImage.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
	}

	private func superView() -> UIView? {
		let currentWindow = UIApplication
			.shared
			.connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.first(where: { $0 is UIWindowScene })
			.flatMap { $0 as? UIWindowScene }?.windows
			.first(where: \.isKeyWindow)
		if var topController = currentWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			let superView = topController.view
			superView?.addSubview(self)
			return superView
		} else {
			return nil
		}
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
}
