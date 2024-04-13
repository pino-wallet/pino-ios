//
//  PinoButton.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public class PinoButton: UIButton {
	// MARK: - Private properties

	private var loadingView = PinoLoading(size: 22, imageType: .secondary)

	// MARK: - Public properties

	public var title: String? {
		didSet {
			updateTitle(title)
		}
	}

	public var style: Style {
		didSet {
			updateStyle()
		}
	}

	public var selectedStyle: Style {
		switch style {
		case .active:
			return .activeSelected
		case .secondary:
			return .secondarySelected
		default:
			return style
		}
	}

	// MARK: - Initializers

	public init(style: Style, title: String? = nil) {
		self.title = title
		self.style = style
		super.init(frame: .zero)
		setupLoading()
		updateStyle()
		updateTitle(title)
		setupConstraints()
	}

	public required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - UIButton overrides

	override public func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = style.cornerRadius ?? 12
	}

	// MARK: - Private methods

	private func setupConstraints() {
		let constraint = heightAnchor.constraint(equalToConstant: 56)
		constraint.priority = UILayoutPriority(999)
		constraint.isActive = true
	}

	private func updateStyle() {
		backgroundColor = style.backgroundColor
		setTitleColor(style.titleColor, for: .normal)
		setTitleColor(selectedStyle.titleColor, for: .highlighted)
		titleLabel?.font = style.font
		layer.borderColor = style.borderColor?.cgColor
		layer.borderWidth = 1.2
		clipsToBounds = true

		switch style {
		case .loading:
			isEnabled = false
			loadingView.isHidden = false
			updateTitle(nil)
		case .clearLoading:
			isEnabled = false
			loadingView.isHidden = false
			loadingView.imageType = .primary
			updateTitle(nil)
		case .deactive:
			isEnabled = false
			loadingView.isHidden = true
		case .secondary:
			isEnabled = true
			updateTitle(title)
			loadingView.isHidden = true
		default:
			isEnabled = true
			updateTitle(title)
			loadingView.isHidden = true
		}
	}

	private func updateTitle(_ title: String?) {
		setTitle(title, for: .normal)
	}

	private func setupLoading() {
		addSubview(loadingView)
		loadingView.isHidden = true
		loadingView.pin(.centerX, .centerY)
	}

	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		backgroundColor = selectedStyle.backgroundColor
		layer.borderColor = selectedStyle.borderColor?.cgColor
	}

	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		backgroundColor = style.backgroundColor
		layer.borderColor = style.borderColor?.cgColor
	}
}
