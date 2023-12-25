//
//  TitleWithInfo.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/13/23.
//

import UIKit

class TitleWithInfo: UIButton {
	// MARK: - Closures

	public var presentActionSheet: (_ actionSheet: InfoActionSheet, _ completion: @escaping () -> Void)
		-> Void = { _, _ in }

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let infoActionSheetIcon = UIImageView()
	private var infoActionSheet: InfoActionSheet!
	private var customConfiguration = UIButton.Configuration.filled()

	// MARK: - Public Properties

	override var isHighlighted: Bool {
		didSet {
			if isHighlighted && showInfoActionSheet {
				customConfiguration.attributedTitle?.foregroundColor = .Pino.gray3
				configuration = customConfiguration
			} else {
				customConfiguration.attributedTitle?.foregroundColor = .Pino.secondaryLabel
				configuration = customConfiguration
			}
		}
	}

	public var title: String! = "" {
		didSet {
			var attributedTitle = AttributedString(title)
			attributedTitle.foregroundColor = .Pino.secondaryLabel
			attributedTitle.font = .PinoStyle.mediumCallout
			customConfiguration.attributedTitle = attributedTitle
			configuration = customConfiguration
		}
	}

	public var showInfoActionSheet = true {
		didSet {
			if showInfoActionSheet {
				infoActionSheetIcon.isHidden = false
				customConfiguration.image = UIImage(named: "alert")
				configuration = customConfiguration
			} else {
				infoActionSheetIcon.isHidden = true
				customConfiguration.image = nil
				configuration = customConfiguration
			}
		}
	}

	public var customTextFont: UIFont! {
		didSet {
			customConfiguration.attributedTitle?.font = customTextFont
			configuration = customConfiguration
		}
	}

	public var customTextColor: UIColor! {
		didSet {
			customConfiguration.attributedTitle?.foregroundColor = customTextColor
			configuration = customConfiguration
		}
	}

	// MARK: - Initializers

	convenience init() {
		self.init(actionSheetTitle: "", actionSheetDescription: "")
	}

	init(actionSheetTitle: String, actionSheetDescription: String) {
		self.infoActionSheet = InfoActionSheet(title: actionSheetTitle, description: actionSheetDescription)

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		customConfiguration.imagePadding = 2
		customConfiguration.imagePlacement = .trailing
		customConfiguration.cornerStyle = .fixed
		customConfiguration.image = UIImage(named: "alert")

		addTarget(self, action: #selector(onIconTap), for: .touchUpInside)
	}

	private func setupStyles() {
		customConfiguration.background.backgroundColor = .Pino.clear
		customConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
		configuration = customConfiguration
	}

	private func setupConstraints() {
		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

		widthAnchor.constraint(lessThanOrEqualToConstant: 108).isActive = true
	}

	private func setupDismissGesture() {
		let dismissTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDismiss))
		infoActionSheet.view.superview?.subviews[0].addGestureRecognizer(dismissTapGestureRecognizer)
		infoActionSheet.view.superview?.subviews[0].isUserInteractionEnabled = true
	}

	@objc
	private func onIconTap() {
		presentActionSheet(infoActionSheet, setupDismissGesture)
		infoActionSheet.view.superview?.isUserInteractionEnabled = true
	}

	@objc
	private func onDismiss() {
		infoActionSheet.dismiss(animated: true)
	}
}
