//
//  CustomAssetViewSection.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/5/23.
//
import UIKit

class CustomAssetViewItem: UIView {
	// Typealias
	typealias presentTooltipAlertClosureType = (_ tooltipTitle: String, _ tooltipDescription: String) -> Void

	// MARK: - Closure

	var presentTooltipAlertClosure: presentTooltipAlertClosureType?

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

	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let betweenStackView = UIStackView()
	private let infoStackView = UIStackView()
	private let titleLabel = UILabel()
	private let tooltipIconViewButton = UIButton()
	private var assetIconView: UIImageView? {
		didSet {
			setupAssetIconViewConstraints()
		}
	}

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
		addSubview(mainStackView)

		// Setup title stackview
		titleStackView.axis = .horizontal
		titleStackView.alignment = .center
		titleStackView.spacing = 2
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(tooltipIconViewButton)

		// Setup center stackview
		betweenStackView.alignment = .center

		// Setup main stackview
		mainStackView.axis = .horizontal
		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(betweenStackView)
		mainStackView.addArrangedSubview(infoStackView)

		// Setup tooltipViewButton
		tooltipIconViewButton.setImage(UIImage(named: "tooltip"), for: .normal)
		tooltipIconViewButton.addTarget(self, action: #selector(handleOpenTooltip(_:)), for: .touchUpInside)

		// Setup info stack view
		infoStackView.axis = .horizontal
		infoStackView.alignment = .center
		infoStackView.spacing = 4
		if let infoIconName = infoIconName {
			assetIconView = UIImageView(image: UIImage(named: infoIconName))
			infoStackView.addArrangedSubview(assetIconView ?? UIImageView())
		}
		infoStackView.addArrangedSubview(infoView)
	}

	private func setupConstraints() {
		pin(.fixedHeight(24))
		titleStackView.pin(.fixedHeight(24))
		infoStackView.pin(.fixedHeight(24))
		mainStackView.pin(.allEdges(to: superview))
	}

	private func setupAssetIconViewConstraints() {
		assetIconView?.pin(.fixedHeight(20), .fixedWidth(20))
	}

	// Handle open tooltip
	@objc
	func handleOpenTooltip(_ sender: UIGestureRecognizer) {
		presentTooltipAlertClosure?(titleText, tooltipText)
	}
}
