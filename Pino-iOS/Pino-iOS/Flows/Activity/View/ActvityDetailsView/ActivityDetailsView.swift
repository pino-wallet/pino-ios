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

	typealias presentActionSheetType = (_ actionSheet: UIAlertController) -> Void

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
	private let activityDetailRefreshControl = UIRefreshControl()
    private let speedUpButton = UIButton()
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
				self?.presentActionSheet(actionSheet)
			}
		)

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

		var viewStatusButtonConfigurations = PinoButton.Configuration.plain()
        viewStatusButtonConfigurations.image = UIImage(named: activityDetailsVM.viewEthScanIconName)
        viewStatusButtonConfigurations.imagePadding = 4
        viewStatusButtonConfigurations.imagePlacement = .trailing
        viewStatusButtonConfigurations.background.backgroundColor = .Pino.clear
        viewStatusButtonConfigurations.background.customView?.layer.borderWidth = 1.2
        viewStatusButtonConfigurations.background.customView?.layer.borderColor = UIColor.Pino.primary.cgColor
		var viewStatusButtonAttributedTitle = AttributedString(activityDetailsVM.viewEthScanTitle)
        viewStatusButtonAttributedTitle.font = .PinoStyle.semiboldBody
        viewStatusButtonAttributedTitle.foregroundColor = .Pino.primary
        viewStatusButtonConfigurations.attributedTitle = viewStatusButtonAttributedTitle
		viewEthScanButton.configuration = viewStatusButtonConfigurations

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
		#warning("later we should show footer container view for other tokens transaction")

		mainStackView.setCustomSpacing(16, after: activityDetailsHeader)
        
        var speedButtonUpConfigurations = PinoButton.Configuration.filled()
        speedButtonUpConfigurations.image = UIImage(named: activityDetailsVM.speedUpIconName)
        speedButtonUpConfigurations.imagePadding = 10
        speedButtonUpConfigurations.imagePlacement = .trailing
        speedButtonUpConfigurations.background.backgroundColor = .Pino.primary
        speedButtonUpConfigurations.background.cornerRadius = 12
        var speedUpButtonAttributedTitle = AttributedString(activityDetailsVM.speedUpText)
        speedUpButtonAttributedTitle.font = .PinoStyle.semiboldCallout
        speedUpButtonAttributedTitle.foregroundColor = .Pino.white
        speedButtonUpConfigurations.attributedTitle = speedUpButtonAttributedTitle
        speedUpButton.configuration = speedButtonUpConfigurations
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
        speedUpButton.pin(.horizontalEdges(to: layoutMarginsGuide, padding: 0), .bottom(to: safeAreaLayoutGuide, padding: speedUpActivityButtomPadding), .fixedHeight(56))
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
        let speedUpActionSheet = SpeedUpAlertViewController(activityDetailsVM: activityDetailsVM)
        presentActionSheet(speedUpActionSheet)
    }
}
