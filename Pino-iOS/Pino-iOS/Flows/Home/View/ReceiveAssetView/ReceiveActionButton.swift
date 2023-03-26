//
//  ReceiveViewActionButton.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit

class ReceiveActionButton: UIView {
	// MARK: - Public Properties

	public var iconName: String {
		didSet {
            let buttonIcon = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
			iconView.image = buttonIcon
            iconView.tintColor = .Pino.white
		}
	}

	public var titleText: String {
		didSet {
			titleLabel.text = titleText
		}
	}

	public var onTap: () -> Void

	// MARK: - Private Properties

	private let iconView = UIImageView()
	private let titleLabel = PinoLabel(style: .receiveButtonActionTitle, text: "")
    private let contentStackView = UIStackView()
    
	// MARK: - Initializers

	init(iconName: String = "", titleText: String = "", onTap: @escaping () -> Void = {}) {
		self.iconName = iconName
		self.titleText = titleText
		self.onTap = onTap
		super.init(frame: .zero)
		setupView()
        setupConstraints()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onGestureTap))
        contentStackView.addGestureRecognizer(tapGesture)
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 4
        
        layer.cornerRadius = 20
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(iconView)
		titleLabel.textAlignment = .center
        
        backgroundColor = .Pino.primary
        
        
        addSubview(contentStackView)
	}
    
    private func setupConstraints() {
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        contentStackView.pin(.horizontalEdges(to: superview, padding: 10), .centerY())
        iconView.pin(.fixedHeight(22), .fixedWidth(22))
    }

	@objc
	private func onGestureTap() {
		onTap()
	}
}

extension PinoLabel.Style {
	fileprivate static let receiveButtonActionTitle = PinoLabel.Style(
		textColor: .Pino.white,
		font: .PinoStyle.semiboldSubheadline,
		numberOfLine: 0,
		lineSpacing: 6
	)
}
