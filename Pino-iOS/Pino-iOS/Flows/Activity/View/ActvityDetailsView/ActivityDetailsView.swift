//
//  ActivityDetailsView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/11/23.
//

import Combine
import UIKit

class ActivityDetailsView: UIScrollView {
	// MARK: - TypeAliases

	typealias presentActionSheetType = (_ actionSheet: UIAlertController, _ completion: (() -> Void)?) -> Void

	// MARK: - Closures

	public var presentActionSheet: presentActionSheetType

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let footerContainerView = PinoContainerCard()
	private let footerStackView = UIStackView()
	private let footerIconView = UIImageView()
	private let footerTextLabel = PinoLabel(style: .title, text: "")
	private let footerTextLabelContainer = UIView()
	private let activityDetailRefreshControl = UIRefreshControl()
	private let speedUpButton = PinoButton(style: .active, title: "")
	private var speedUpActionSheet: SpeedUpAlertViewController!
	private var viewEthScanButton: PinoRightSideImageButton!
	private var activityDetailsVM: ActivityDetailsViewModel
	private var activityDetailsHeader: UIView
	private var activityDetailsInfoView: ActivityInfoView!
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Initializers

	init(
		activityDetailsVM: ActivityDetailsViewModel,
		presentActionSheet: @escaping presentActionSheetType,
		activityDetailsHeader: UIView
	) {
		self.activityDetailsVM = activityDetailsVM
		self.presentActionSheet = presentActionSheet
		self.activityDetailsHeader = activityDetailsHeader

		super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 700))

		setupView()
		setupStyles()
		setupConstraintsWithUIType()
		setupRefreshControl()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		activityDetailsInfoView = ActivityInfoView(
			activityDetailsVM: activityDetailsVM,
			presentActionSheet: { [weak self] actionSheet in
				self?.presentActionSheet(actionSheet, nil)
			}
		)
		viewEthScanButton = PinoRightSideImageButton(imageName: activityDetailsVM.viewEthScanIconName, style: .clear)

		viewEthScanButton.addTarget(self, action: #selector(openEthScan), for: .touchUpInside)

		speedUpButton.addTarget(self, action: #selector(openSpeedUpActionSheet), for: .touchUpInside)

		footerTextLabelContainer.addSubview(footerTextLabel)

		footerStackView.addArrangedSubview(footerIconView)
		footerStackView.addArrangedSubview(footerTextLabelContainer)

		footerContainerView.addSubview(footerStackView)

		mainStackView.addArrangedSubview(activityDetailsHeader)
		mainStackView.addArrangedSubview(activityDetailsInfoView)
		mainStackView.addArrangedSubview(footerContainerView)
		mainStackView.addArrangedSubview(viewEthScanButton)

		addSubview(mainStackView)
		addSubview(speedUpButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		viewEthScanButton.title = activityDetailsVM.viewEthScanTitle

		mainStackView.axis = .vertical
		mainStackView.spacing = 24

		footerStackView.axis = .horizontal
		footerStackView.spacing = 4
		footerStackView.alignment = .top

		footerTextLabel.font = .PinoStyle.mediumCallout
		footerTextLabel.text = activityDetailsVM.otherTokenTransactionMessage
		footerTextLabel.numberOfLines = 0

		footerIconView.image = UIImage(named: activityDetailsVM.otherTokenTransactionIconName)

		footerContainerView.isHidden = true

		mainStackView.setCustomSpacing(16, after: activityDetailsHeader)

		speedUpButton.title = activityDetailsVM.speedUpText
		speedUpButton.setImage(UIImage(named: activityDetailsVM.speedUpIconName), for: .normal)
		speedUpButton.setConfiguraton(font: .PinoStyle.semiboldCallout!, imagePadding: 7)
	}

	private func setupConstraintsWithUIType() {
		footerStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

		footerStackView.pin(.horizontalEdges(padding: 8), .verticalEdges(padding: 10))
		footerTextLabel.pin(.top(padding: 4), .horizontalEdges(padding: 0), .bottom(padding: 0))

		viewEthScanButton.pin(
			.fixedHeight(56)
		)
		footerIconView.pin(.fixedHeight(20), .fixedWidth(20))

		let safeAreaExists = (window?.safeAreaInsets.bottom != 0) // Check if safe area exists
		let speedUpActivityButtomPadding: CGFloat = safeAreaExists ? 12 : 32
		mainStackView.pin(.horizontalEdges(to: layoutMarginsGuide, padding: 0), .top(to: contentLayoutGuide, padding: 24))
		speedUpButton.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: safeAreaLayoutGuide, padding: speedUpActivityButtomPadding)
		)
	}

	private func setupRefreshControl() {
		indicatorStyle = .white
		activityDetailRefreshControl.tintColor = .Pino.green2
		activityDetailRefreshControl.addAction(UIAction(handler: { _ in
			self.refreshData()
		}), for: .valueChanged)
		refreshControl = activityDetailRefreshControl
	}

	private func refreshData() {
		activityDetailsVM.refreshData()
	}

	private func setupBindings() {
		activityDetailsVM.$properties.sink { properties in
			self.refreshControl?.endRefreshing()
			if properties!.status != .pending {
				self.speedUpButton.isHidden = true
			}
		}.store(in: &cancellables)
	}

	@objc
	private func openEthScan() {
		UIApplication.shared.open(activityDetailsVM.properties.exploreURL)
	}

	@objc
	private func openSpeedUpActionSheet() {
		speedUpActionSheet = SpeedUpAlertViewController(activityDetailsVM: activityDetailsVM)
		presentActionSheet(speedUpActionSheet) {
			let speedUpAlertBackgroundTappedGesture = UITapGestureRecognizer(
				target: self,
				action: #selector(self.speedUpAlertBackgroundTapped)
			)
			self.speedUpActionSheet.view.superview?.subviews[0]
				.addGestureRecognizer(speedUpAlertBackgroundTappedGesture)
			self.speedUpActionSheet.view.superview?.subviews[0].isUserInteractionEnabled = true
		}
	}

	@objc
	private func speedUpAlertBackgroundTapped() {
		if speedUpActionSheet.isDismissable {
			speedUpActionSheet.dismiss(animated: true)
		}
	}
}
