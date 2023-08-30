//
//  RightSideImageButton.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 8/29/23.
//
import UIKit

public class PinoRightSideImageButton: UIButton {
	// MARK: - Public Properties

	public var imageName: String {
		didSet {
			customConfiguration.image = UIImage(named: imageName)
			configuration = customConfiguration
		}
	}

	public var style: Style {
		didSet {
			updateStyle()
		}
	}

	public var title = "" {
		didSet {
			var attributedTitle = AttributedString(title)
			attributedTitle.foregroundColor = style.titleColor
			attributedTitle.font = .PinoStyle.semiboldCallout
			customConfiguration.attributedTitle = attributedTitle
			configuration = customConfiguration
		}
	}

	public var corderRadius: CGFloat = 12 {
		didSet {
			customConfiguration.background.cornerRadius = corderRadius
			configuration = customConfiguration
		}
	}

	// MARK: - Private Properties

	private var customConfiguration = UIButton.Configuration.filled()

	// MARK: - Initializers

	init(imageName: String, style: Style) {
		self.imageName = imageName
		self.style = style

		super.init(frame: .zero)

		setupStyles()
		setupConstraints()
		updateStyle()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupStyles() {
		customConfiguration.imagePadding = 4
		customConfiguration.imagePlacement = .trailing
		customConfiguration.background.customView?.layer.borderWidth = 1.2
		customConfiguration.cornerStyle = .fixed
		customConfiguration.background.cornerRadius = 12
		customConfiguration.image = UIImage(named: imageName)
		configuration = customConfiguration
	}

	private func setupConstraints() {
		heightAnchor.constraint(equalToConstant: 56).isActive = true
	}

	private func updateStyle() {
		customConfiguration.background.customView?.layer.borderColor = style.borderColor?.cgColor
		customConfiguration.background.backgroundColor = style.backgroundColor
		customConfiguration.image = customConfiguration.image?.withTintColor(style.titleColor)
	}
}
