//
//  CustomAssetViewSection.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/5/23.
//

import UIKit

class CustomAssetViewItem: UIView {
	// MARK: - Public Properties

	public var titleText: String
	public var tooltipText: String
	public var infoView: UIView
	public var infoIconName: String? {
		didSet {
			setupView()
		}
	}

	// MARK: - Private Properties

	private let titleLabel = UILabel()
	private let tooltipIconViewButton = UIButton()

	init(titleText: String, tooltipText: String, infoView: UIView) {
		self.titleText = titleText
		self.tooltipText = tooltipText
		self.infoView = infoView

		super.init(frame: .zero)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		// Setup titleLabel
		titleLabel.text = titleText
		titleLabel.font = UIFont.PinoStyle.mediumBody
		titleLabel.textColor = .Pino.secondaryLabel

		// Setup subviews
		addSubview(titleLabel)
		addSubview(tooltipIconViewButton)
		addSubview(infoView)

		// Setup tooltipViewButton
		tooltipIconViewButton.setImage(UIImage(named: "tooltip"), for: .normal)
		tooltipIconViewButton.addTarget(self, action: #selector(handleOpenTooltip(_:)), for: .touchUpInside)

		if let infoIconName = infoIconName {
			let assetIconView = UIImageView(image: UIImage(named: infoIconName))
			addSubview(assetIconView)
			assetIconView.pin(
				.fixedWidth(20),
				.fixedHeight(20),
				.relative(.trailing, -4, to: infoView, .leading),
				.centerY(to: superview)
			)
		}
	}

	private func setupConstraints() {
		pin(.fixedHeight(24))
		titleLabel.pin(.leading(to: superview, padding: 0), .centerY(to: superview))
		tooltipIconViewButton.pin(
			.fixedHeight(16),
			.fixedWidth(16),
			.centerY(to: superview),
			.relative(.leading, 2, to: titleLabel, .trailing)
		)
		infoView.pin(.trailing(to: superview, padding: 0), .centerY(to: superview))
	}

	// Handle open tooltip
	@objc
	func handleOpenTooltip(_ sender: UIGestureRecognizer) {
		let tooltipAlert = InfoActionSheet(title: titleText, message: tooltipText, preferredStyle: .alert)
		tooltipAlert.addAction(UIAlertAction(title: "Got it", style: .cancel))
		guard let viewController = next?.next?.next?.next as? UIViewController else {
			return
		}
		viewController.present(tooltipAlert, animated: true)
	}
}
