//
//  ActivityDetailsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import UIKit

class ActivityDetailsView: UIView {
	// MARK: - TypeAliases

	typealias presentActionSheetType = (_ actionSheet: InfoActionSheet) -> Void

	// MARK: - Closures

	public var presentActionSheet: presentActionSheetType

	// MARK: - Private Properties

	private var activityDetailsVM: ActivityDetailsViewModel
	private var activityDetailsHeader: UIView
	private var activityDetailsInfoView: ActivityInfoView!
	private let mainStackView = UIStackView()
	private let viewEthScanButton = UIButton()
	private let footerContainerView = PinoContainerCard()
	private let footerStackView = UIStackView()
	private let footerIconView = UIImageView()
	private let footerTextLabel = PinoLabel(style: .title, text: "")
	private let footerTextLabelContainer = UIView()

	// MARK: - Initializers

	init(
		activityDetailsVM: ActivityDetailsViewModel,
		presentActionSheet: @escaping presentActionSheetType,
		activityDetailsHeader: UIView
	) {
		self.activityDetailsVM = activityDetailsVM
		self.presentActionSheet = presentActionSheet
		self.activityDetailsHeader = activityDetailsHeader

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraintsWithUIType()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		activityDetailsInfoView = ActivityInfoView(
			activityDetailsVM: activityDetailsVM,
			presentActionSheet: { [weak self] actionSheet in
				self?.presentActionSheet(actionSheet)
			}
		)

		viewEthScanButton.addTarget(self, action: #selector(openEthScan), for: .touchUpInside)

		footerTextLabelContainer.addSubview(footerTextLabel)

		footerStackView.addArrangedSubview(footerIconView)
		footerStackView.addArrangedSubview(footerTextLabelContainer)

		footerContainerView.addSubview(footerStackView)

		mainStackView.addArrangedSubview(activityDetailsHeader)
		mainStackView.addArrangedSubview(activityDetailsInfoView)
		mainStackView.addArrangedSubview(footerContainerView)
		mainStackView.addArrangedSubview(viewEthScanButton)

		addSubview(mainStackView)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		var viewStatusConfigurations = PinoButton.Configuration.plain()
		viewStatusConfigurations.image = UIImage(named: activityDetailsVM.viewEthScanIconName)
		viewStatusConfigurations.imagePadding = 4
		viewStatusConfigurations.imagePlacement = .trailing
		viewStatusConfigurations.background.backgroundColor = .Pino.clear
		viewStatusConfigurations.background.customView?.layer.borderWidth = 1.2
		viewStatusConfigurations.background.customView?.layer.borderColor = UIColor.Pino.primary.cgColor
		var attributedTitle = AttributedString(activityDetailsVM.viewEthScanTitle)
		attributedTitle.font = .PinoStyle.semiboldBody
		attributedTitle.foregroundColor = .Pino.primary
		viewStatusConfigurations.attributedTitle = attributedTitle
		viewEthScanButton.configuration = viewStatusConfigurations

		mainStackView.axis = .vertical
		mainStackView.spacing = 24

		footerStackView.axis = .horizontal
		footerStackView.spacing = 4
		footerStackView.alignment = .top

		footerTextLabel.font = .PinoStyle.mediumCallout
		footerTextLabel.text = activityDetailsVM.unknownTransactionMessage
		footerTextLabel.numberOfLines = 0

		footerIconView.image = UIImage(named: activityDetailsVM.unknownTransactionIconName)

		footerContainerView.isHidden = true

		if activityDetailsVM.uiType == .unknown {
			activityDetailsHeader.isHidden = true
			footerContainerView.isHidden = false
		} else {
			mainStackView.setCustomSpacing(16, after: activityDetailsHeader)
		}
	}

	private func setupConstraintsWithUIType() {
		footerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

		footerStackView.pin(.horizontalEdges(padding: 8), .verticalEdges(padding: 10))
		footerTextLabel.pin(.top(padding: 4), .horizontalEdges(padding: 0), .bottom(padding: 0))

		viewEthScanButton.pin(
			.fixedHeight(56)
		)
		footerIconView.pin(.fixedHeight(20), .fixedWidth(20))

		mainStackView.pin(.horizontalEdges(padding: 16), .top(to: layoutMarginsGuide, padding: 24))
	}

	@objc
	private func openEthScan() {
		#warning("this is for test")
		let url = URL(string: "http://www.google.com")!
		UIApplication.shared.open(url)
	}
}
