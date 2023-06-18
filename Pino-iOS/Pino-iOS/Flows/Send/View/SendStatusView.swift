//
//  SendStatusView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/18/23.
//

import UIKit

class SendStatusView: UIView {
	// MARK: - Public Properties

	#warning("i think we should pass confirmSendVM here to bind send response and update view status")

	// MARK: - Closures

	public var onDissmiss: () -> Void = {}
	public var toggleIsModalInPresentation: (_: Bool) -> Void

	// MARK: - Private Properties

	private let dissmissButton = UIButton()
	private let clearNavigationBar = ClearNavigationBar()
	private let navigationBarRightView = UIView()
	private let pendingStackView = UIStackView()
	private let loadingContainer = UIView()
	private let loading = PinoLoading(size: 48)
	private let loadingTextLabel = PinoLabel(style: .description, text: "")
	private let statusIconView = UIImageView()
	private let statusTitleLabel = PinoLabel(style: .title, text: "")
	private let statusDescriptionLabel = PinoLabel(style: .description, text: "")
	private let closeButton = PinoButton(style: .secondary)
	private let mainStackView = UIStackView()
	private let statusInfoStackView = UIStackView()
	private let viewStatusButton = UIButton()
	private var sendStatusVM = SendStatusViewModel()

	private enum PageStatuses {
		case pending
		case success
		case failed
	}

	private var pageStatus: PageStatuses = .pending {
		didSet {
			updateViewWithPageStatus(pageStatus: pageStatus)
		}
	}

	// MARK: - Initializers

	init(toggleIsModalInPresentation: @escaping (_: Bool) -> Void) {
		self.toggleIsModalInPresentation = toggleIsModalInPresentation
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		updateViewWithPageStatus(pageStatus: pageStatus)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		navigationBarRightView.addSubview(dissmissButton)

		clearNavigationBar.setRightSectionView(view: navigationBarRightView)

		dissmissButton.addTarget(self, action: #selector(onDissmissTap), for: .touchUpInside)

		closeButton.addTarget(self, action: #selector(onDissmissTap), for: .touchUpInside)

		viewStatusButton.addTarget(self, action: #selector(openViewStatusURL), for: .touchUpInside)

		loadingContainer.addSubview(loading)

		pendingStackView.addArrangedSubview(loadingContainer)
		pendingStackView.addArrangedSubview(loadingTextLabel)

		statusInfoStackView.addArrangedSubview(statusIconView)
		statusInfoStackView.addArrangedSubview(statusTitleLabel)
		statusInfoStackView.addArrangedSubview(statusDescriptionLabel)

		mainStackView.addArrangedSubview(statusInfoStackView)
		mainStackView.addArrangedSubview(viewStatusButton)

		addSubview(clearNavigationBar)
		addSubview(pendingStackView)
		addSubview(mainStackView)
		addSubview(closeButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		loadingTextLabel.font = .PinoStyle.mediumBody
		loadingTextLabel.text = sendStatusVM.sendingToNetworkText
		loadingTextLabel.numberOfLines = 0
		loadingTextLabel.textAlignment = .center

		loading.style = .large
		loading.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

		pendingStackView.axis = .vertical
		pendingStackView.spacing = 16
		pendingStackView.alignment = .center

		closeButton.setTitle(sendStatusVM.closeButtonText, for: .normal)

		mainStackView.axis = .vertical
		mainStackView.spacing = 65

		statusInfoStackView.axis = .vertical
		statusInfoStackView.spacing = 20
		statusInfoStackView.alignment = .center

		statusDescriptionLabel.font = .PinoStyle.mediumBody

		statusTitleLabel.font = .PinoStyle.semiboldTitle2

		var viewStatusConfigurations = PinoButton.Configuration.plain()
		viewStatusConfigurations.title = sendStatusVM.viewStatusText
		viewStatusConfigurations.image = UIImage(named: sendStatusVM.viewStatusIconName)
		viewStatusConfigurations.imagePadding = 4
		viewStatusConfigurations.imagePlacement = .trailing
		viewStatusConfigurations.background.backgroundColor = .Pino.clear
		viewStatusConfigurations.background.customView?.layer.borderWidth = 1.2
		viewStatusConfigurations.background.customView?.layer.borderColor = UIColor.Pino.primary.cgColor
		var attributedTitle = AttributedString(sendStatusVM.viewStatusText)
		attributedTitle.font = .PinoStyle.semiboldBody
		attributedTitle.foregroundColor = .Pino.primary
		viewStatusConfigurations.attributedTitle = attributedTitle
		viewStatusButton.configuration = viewStatusConfigurations

		dissmissButton.setImage(UIImage(named: sendStatusVM.navigationDissmissIconName), for: .normal)
	}

	private func setupConstraints() {
		pendingStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 154).isActive = true
		loadingTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 190).isActive = true

		loadingContainer.pin(.fixedWidth(48), .fixedHeight(48))
		dissmissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		pendingStackView.pin(.centerX(), .relative(.top, 288, to: clearNavigationBar, .bottom))
		statusIconView.pin(.fixedWidth(56), .fixedHeight(56))
		mainStackView.pin(.relative(.top, 151, to: clearNavigationBar, .bottom), .horizontalEdges(padding: 16))
		viewStatusButton.pin(.fixedHeight(56))
		closeButton.pin(.bottom(padding: 32), .horizontalEdges(padding: 16))
	}

	private func updateViewWithPageStatus(pageStatus: PageStatuses) {
		switch pageStatus {
		case .pending:
			pendingStackView.isHidden = false

			mainStackView.isHidden = true

			dissmissButton.isHidden = true

			toggleIsModalInPresentation(true)

			closeButton.isHidden = true
		case .success:
			statusIconView.image = UIImage(named: sendStatusVM.sentIconName)

			statusTitleLabel.text = sendStatusVM.transactionSentText

			statusDescriptionLabel.text = sendStatusVM.transactionSentInfoText

			setupAdditionalSettingsForLabels()

			pendingStackView.isHidden = true

			viewStatusButton.isHidden = false

			mainStackView.isHidden = false

			dissmissButton.isHidden = false

			toggleIsModalInPresentation(false)

			closeButton.isHidden = false
		case .failed:
			statusIconView.image = UIImage(named: sendStatusVM.failedIconName)

			statusTitleLabel.text = sendStatusVM.somethingWentWrongText

			statusDescriptionLabel.text = sendStatusVM.tryAgainLaterText

			setupAdditionalSettingsForLabels()

			pendingStackView.isHidden = true

			viewStatusButton.isHidden = true

			mainStackView.isHidden = false

			dissmissButton.isHidden = false

			toggleIsModalInPresentation(false)

			closeButton.isHidden = false
		}
	}

	private func setupAdditionalSettingsForLabels() {
		statusDescriptionLabel.textAlignment = .center
		statusDescriptionLabel.numberOfLines = 0

		statusTitleLabel.textAlignment = .center
		statusTitleLabel.numberOfLines = 0
	}

	private func setupBindings() {
		#warning("i think we should listen to confirmSendVM changes to change view status here")
	}

	@objc
	func onDissmissTap() {
		onDissmiss()
	}

	@objc
	func openViewStatusURL() {
		#warning("this URL is for testing and should be updated from confirmSendVM")
		let viewStatusUrl = URL(string: "http://www.google.com")
		UIApplication.shared.open(viewStatusUrl!)
	}
}
