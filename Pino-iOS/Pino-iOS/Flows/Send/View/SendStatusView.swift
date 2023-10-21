//
//  SendStatusView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/18/23.
//

import UIKit

class SendStatusView: UIView {
	// MARK: - Public Properties

	public enum PageStatus {
		case pending
		case success
		case failed
	}

	public var pageStatus: PageStatus = .pending {
		didSet {
			updateViewWithPageStatus(pageStatus: pageStatus)
		}
	}
    
    public var txHash: String

	// MARK: - Closures

	public var onDissmiss: () -> Void = {}
	public var toggleIsModalInPresentation: (_: Bool) -> Void

	// MARK: - Private Properties

	private let dissmissButton = UIButton()
	private let clearNavigationBar = ClearNavigationBar()
	private let navigationBarRightView = UIView()
	private let pendingStackView = UIStackView()
	private let loading = PinoLoading(size: 50)
	private let loadingTextLabel = PinoLabel(style: .description, text: "")
	private let statusIconView = UIImageView()
	private let statusTitleLabel = PinoLabel(style: .title, text: "")
	private let statusDescriptionLabel = PinoLabel(style: .description, text: "")
	private let closeButton = PinoButton(style: .secondary)
	private let mainStackView = UIStackView()
	private let statusInfoStackView = UIStackView()
	private let viewStatusButton = UIButton()
	private var sendStatusVM = SendStatusViewModel()

	// MARK: - Initializers

    init(toggleIsModalInPresentation: @escaping (_: Bool) -> Void, txHash: String = "") {
		self.toggleIsModalInPresentation = toggleIsModalInPresentation
        self.txHash = txHash
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

		pendingStackView.addArrangedSubview(loading)
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

		dissmissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		pendingStackView.pin(.centerX(), .centerY(to: layoutMarginsGuide))
		statusIconView.pin(.fixedWidth(56), .fixedHeight(56))
		mainStackView.pin(.centerY(to: layoutMarginsGuide), .horizontalEdges(padding: 16))
		viewStatusButton.pin(.fixedHeight(56))
		closeButton.pin(.bottom(padding: 32), .horizontalEdges(padding: 16))
	}

	private func updateViewWithPageStatus(pageStatus: PageStatus) {
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

	@objc
	private func onDissmissTap() {
		onDissmiss()
	}

	@objc
	private func openViewStatusURL() {
        let viewStatusUrl = URL(string: txHash.ethScanTxURL)
		UIApplication.shared.open(viewStatusUrl!)
	}
}
