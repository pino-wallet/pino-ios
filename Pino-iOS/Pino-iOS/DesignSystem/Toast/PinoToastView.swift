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
		if !isShowingToast {
			isShowingToast = true
			let currentWindow = UIApplication.shared.connectedScenes
				.filter { $0.activationState == .foregroundActive }
				.first(where: { $0 is UIWindowScene })
				.flatMap { $0 as? UIWindowScene }?.windows
				.first(where: \.isKeyWindow)
			guard let superView = currentWindow?.rootViewController?.view
			else { fatalError("Toast view has not been added to any view") }
			currentWindow?.addSubview(self)

			switch alignment {
			case .top:
				pin(.centerX, .top(padding: 80))
				frame.origin = CGPoint(x: frame.origin.x, y: -28)
				UIView
					.animate(
						withDuration: 0.8,
						delay: 0,
						usingSpringWithDamping: 0.6,
						initialSpringVelocity: 0.5
					) { [weak self] in
						guard let self else { return }
						self.frame.origin = CGPoint(x: self.frame.origin.x, y: 80)
					} completion: { _ in
						UIView.animate(
							withDuration: 0.8,
							delay: 1.2,
							usingSpringWithDamping: 0.6,
							initialSpringVelocity: 0.5
						) { [weak self] in
							guard let self else { return }
							self.frame.origin = CGPoint(x: self.frame.origin.x, y: -28)
						} completion: { _ in
							self.isShowingToast = false
							self.removeFromSuperview()
						}
					}
			case .bottom:
				pin(.centerX, .bottom(padding: 100))
				frame.origin = CGPoint(x: frame.origin.x, y: superView.frame.height)
				UIView
					.animate(
						withDuration: 0.8,
						delay: 0,
						usingSpringWithDamping: 0.7,
						initialSpringVelocity: 0.3
					) { [weak self] in
						guard let self else { return }
						self.frame.origin = CGPoint(x: self.frame.origin.x, y: superView.frame.height - 100)
					} completion: { _ in
						UIView.animate(
							withDuration: 0.4,
							delay: 2,
							usingSpringWithDamping: 0.9,
							initialSpringVelocity: 0.3
						) { [weak self] in
							guard let self else { return }
							self.frame.origin = CGPoint(x: self.frame.origin.x, y: superView.frame.height)
						} completion: { _ in
							self.isShowingToast = false
							self.removeFromSuperview()
						}
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
		layer.cornerRadius = 16

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
			.fixedHeight(32)
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
