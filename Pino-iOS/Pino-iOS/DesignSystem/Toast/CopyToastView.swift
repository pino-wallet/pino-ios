//
//  CopyToastView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/11/23.
//

import UIKit

public class CopyToastView: UIView {
	// MARK: - Private Properties

	private let toastLabel = UILabel()
	private var isShowingToast = false

	// MARK: - Public Properties

	public var message: String? {
		didSet {
			toastLabel.text = message
		}
	}

	// MARK: - Initializers

	init(message: String?) {
		self.message = message
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
				alpha = 0
				pin(.centerX, .top(to: superView.layoutMarginsGuide, padding: 32))
				frame.origin = CGPoint(x: frame.origin.x, y: 10)
				updateCornerRadius()
				UIView.animate(
					withDuration: 0.9,
					delay: 0,
					usingSpringWithDamping: 0.7,
					initialSpringVelocity: 0.3
				) { [weak self] in
					guard let self else { return }
					self.alpha = 1
					self.frame.origin = CGPoint(x: self.frame.origin.x, y: 32)
				} completion: { _ in
					UIView.animate(
						withDuration: 0.8,
						delay: 1.2,
						usingSpringWithDamping: 0.7,
						initialSpringVelocity: 0.3
					) { [weak self] in
						guard let self else { return }
						self.alpha = 0
						self.frame.origin = CGPoint(x: self.frame.origin.x, y: 10 + self.frame.height)
					} completion: { _ in
						self.isShowingToast = false
						self.removeFromSuperview()
					}
				}
			} else {
				fatalError("Toast view has not been added to any view")
			}
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(toastLabel)
	}

	private func setupStyle() {
		toastLabel.text = message
		toastLabel.font = .PinoStyle.semiboldFootnote
		toastLabel.textColor = .Pino.white
		backgroundColor = .Pino.primary
	}

	private func setupConstraint() {
		toastLabel.pin(
			.verticalEdges(padding: 7),
			.horizontalEdges(padding: 14)
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
			if let tabBarController = topController as? UITabBarController {
				topController = tabBarController.viewControllers?.first ?? topController
			}
			let superView = topController.view
			superView?.addSubview(self)
			return superView
		} else {
			return nil
		}
	}

	private func updateCornerRadius() {
		layoutIfNeeded()
		layer.cornerRadius = frame.height / 2
	}
}
