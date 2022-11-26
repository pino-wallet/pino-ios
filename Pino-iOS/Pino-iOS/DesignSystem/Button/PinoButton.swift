//
//  PinoButton.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/9/22.
//

import UIKit

public class PinoButton: UIButton {
	// MARK: - Private properties

	private var loadingView = UIActivityIndicatorView()

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
		layer.cornerRadius = 12
	}

	// MARK: - Private methods

	private func setupConstraints() {
		pin(.fixedHeight(56))
	}

	private func updateStyle() {
		backgroundColor = style.backgroundColor
		setTitleColor(style.titleColor, for: .normal)
		titleLabel?.font = UIFont.PinoStyle.semiboldBody
		layer.borderColor = style.borderColor?.cgColor
		layer.borderWidth = 1.2
		clipsToBounds = true

		switch style {
		case .loading:
			isEnabled = false
			loadingEnabled(true)
			updateTitle(nil)
		case .deactive:
			isEnabled = false
			loadingEnabled(false)
		default:
			isEnabled = true
			loadingEnabled(false)
		}
	}

	private func updateTitle(_ title: String?) {
		setTitle(title, for: .normal)
	}

	private func setupLoading() {
		loadingView.color = UIColor.white
		addSubview(loadingView)
		loadingView.pin(.centerX, .centerY)
	}

	private func loadingEnabled(_ isLoading: Bool) {
		if isLoading {
			loadingView.startAnimating()
		} else {
			loadingView.stopAnimating()
		}
	}
}
