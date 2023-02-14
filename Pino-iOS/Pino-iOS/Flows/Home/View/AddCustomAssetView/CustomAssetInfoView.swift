//
//  CustomAssetViewSection.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/5/23.
//
import UIKit

class CustomAssetInfoView: UIView {
	// Typealias
	typealias presentAlertClosureType = (_ alertTitle: String, _ alertDescription: String) -> Void

	// MARK: - Closure

	var presentAlertClosure: presentAlertClosureType?

	// MARK: - Public Properties

	public var titleText: String
	public var alertText: String
	public var infoView: UIView
	public var infoIconImage: UIImage? {
		didSet {
			setupView()
		}
	}

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let titleStackView = UIStackView()
	private let betweenStackView = UIStackView()
	private let infoStackView = UIStackView()
	private let titleLabel: PinoLabel
	private let alertIconButtonView = UIButton()
	private var assetIconView: UIImageView? {
		didSet {
			setupAssetIconViewConstraints()
		}
	}

	// MARK: - Initializers

	init(titleText: String, alertText: String, infoView: UIView) {
		self.titleText = titleText
		self.alertText = alertText
		self.infoView = infoView

		self.titleLabel = PinoLabel(
			style: PinoLabel
				.Style(
					textColor: UIColor.Pino.secondaryLabel,
					font: UIFont.PinoStyle.mediumBody,
					numberOfLine: 0,
					lineSpacing: 6
				),
			text: ""
		)

		super.init(frame: .zero)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - PrivateMethods

	private func setupView() {
		// Setup titleLabel
		titleLabel.text = titleText
		titleLabel.lineBreakMode = .byWordWrapping

		// Setup subviews
		addSubview(mainStackView)

		// Setup title stackview
		titleStackView.axis = .horizontal
		titleStackView.alignment = .center
		titleStackView.spacing = 2
		titleStackView.addArrangedSubview(titleLabel)
		titleStackView.addArrangedSubview(alertIconButtonView)

		// Setup center stackview
		betweenStackView.alignment = .center

		// Setup main stackview
		mainStackView.axis = .horizontal
		mainStackView.addArrangedSubview(titleStackView)
		mainStackView.addArrangedSubview(betweenStackView)
		mainStackView.addArrangedSubview(infoStackView)

		// Setup alertViewButton
		alertIconButtonView.setImage(UIImage(named: "alert"), for: .normal)
		alertIconButtonView.addTarget(self, action: #selector(handlePresentAlert), for: .touchUpInside)

		// Setup info stack view
		infoStackView.axis = .horizontal
		infoStackView.alignment = .center
		infoStackView.spacing = 4
		if let infoIconImage {
			assetIconView = UIImageView(image: infoIconImage)
			infoStackView.addArrangedSubview(assetIconView!)
		}
		infoStackView.addArrangedSubview(infoView)
	}

	private func setupConstraints() {
		titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 138).isActive = true
		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		betweenStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
		mainStackView.pin(.allEdges(to: superview))
	}

	private func setupAssetIconViewConstraints() {
		assetIconView?.pin(.fixedHeight(20), .fixedWidth(20))
	}

	// Handle open alert
	@objc
	func handlePresentAlert() {
		presentAlertClosure?(titleText, alertText)
	}
}
