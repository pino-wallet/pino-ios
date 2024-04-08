//
//  CustomAssetViewSection.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/5/23.
//
import UIKit

class CustomAssetInfoView: UIView {
	// Typealias
	typealias presentAlertClosureType = (_ infoActionSheet: InfoActionSheet, _ completion: @escaping () -> Void) -> Void

	// MARK: - Closure

	var presentAlertClosure: presentAlertClosureType?

	// MARK: - Public Properties

	public var titleText: String
	public var alertText: String
	public var infoView: UIView

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let betweenStackView = UIStackView()
	private let infoStackView = UIStackView()
	private var titleView: TitleWithInfo!

	// MARK: - Initializers

	init(titleText: String, alertText: String, infoView: UIView) {
		self.titleText = titleText
		self.alertText = alertText
		self.infoView = infoView

		super.init(frame: .zero)

		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - PrivateMethods

	private func setupView() {
		titleView = TitleWithInfo(actionSheetTitle: titleText, actionSheetDescription: alertText)
		#warning("for now we should disable showing info actionsheet here")
		titleView.showInfoActionSheet = false
		// Setup titleLabel
		titleView.title = titleText

		// Setup subviews
		addSubview(mainStackView)

		// Setup center stackview
		betweenStackView.alignment = .center

		// Setup main stackview
		mainStackView.alignment = .top
		mainStackView.axis = .horizontal
		mainStackView.addArrangedSubview(titleView)
		mainStackView.addArrangedSubview(betweenStackView)
		mainStackView.addArrangedSubview(infoStackView)

		titleView.presentActionSheet = { infoActionSheet, completion in
			if self.presentAlertClosure != nil {
				self.presentAlertClosure!(infoActionSheet, completion)
			}
		}

		// Setup info stack view
		infoStackView.axis = .horizontal
		infoStackView.alignment = .center
		infoStackView.spacing = 4
		infoStackView.addArrangedSubview(infoView)
	}

	private func setupConstraints() {
		heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		betweenStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
		mainStackView.pin(.allEdges(to: superview))
	}
}
