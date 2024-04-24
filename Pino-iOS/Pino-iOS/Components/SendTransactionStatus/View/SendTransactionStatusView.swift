//
//  SendTransactionStatusView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import Combine
import UIKit

class SendTransactionStatusView: UIView {
	// MARK: - Public Properties

	public var txHash: String

	// MARK: - Closures

	public var onDissmiss: (SendTransactionStatus) -> Void = { _ in }
	public var toggleIsModalInPresentation: (_: Bool) -> Void

	// MARK: - Private Properties

	private let dissmissButton = UIButton()
	private let clearNavigationBar = ClearNavigationBar()
	private let navigationBarRightView = UIView()
	private let loading = PinoLoading(size: 50)
	private let statusIconView = UIImageView()
	private let statusTitleLabel = PinoLabel(style: .title, text: "")
	private let statusDescriptionLabel = PinoLabel(style: .description, text: "")
	private let closeButton = PinoButton(style: .secondary)
	private let statusInfoStackView = UIStackView()
	private let statusTextsStackView = UIStackView()
    private let hapticManager = HapticManager()
	private var sendStatusVM: SendTransactionStatusViewModel
	private var cancellables = Set<AnyCancellable>()
	private var pageStatus: SendTransactionStatus = .pending

	// MARK: - Initializers

	init(
		toggleIsModalInPresentation: @escaping (_: Bool) -> Void,
		txHash: String = "",
		sendStatusVM: SendTransactionStatusViewModel
	) {
		self.toggleIsModalInPresentation = toggleIsModalInPresentation
		self.txHash = txHash
		self.sendStatusVM = sendStatusVM
		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		updateViewWithPageStatus(pageStatus: sendStatusVM.sendTransactionStatus)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		navigationBarRightView.addSubview(dissmissButton)

		clearNavigationBar.setRightSectionView(view: navigationBarRightView)

		dissmissButton.addTarget(self, action: #selector(onDissmissNavigationTap), for: .touchUpInside)
		closeButton.addTarget(self, action: #selector(onDissmissTap), for: .touchUpInside)

		statusTextsStackView.addArrangedSubview(statusTitleLabel)
		statusTextsStackView.addArrangedSubview(statusDescriptionLabel)

		statusInfoStackView.addArrangedSubview(loading)
		statusInfoStackView.addArrangedSubview(statusIconView)
		statusInfoStackView.addArrangedSubview(statusTextsStackView)

		addSubview(clearNavigationBar)
		addSubview(statusInfoStackView)
		addSubview(closeButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.secondaryBackground

		closeButton.setTitle(sendStatusVM.closeButtonText, for: .normal)

		statusInfoStackView.axis = .vertical
		statusInfoStackView.spacing = 24
		statusInfoStackView.alignment = .center

		statusTextsStackView.axis = .vertical
		statusTextsStackView.spacing = 8
		statusTextsStackView.alignment = .center

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

		dissmissButton.setImage(UIImage(named: sendStatusVM.navigationDissmissIconName), for: .normal)
	}

	private func setupConstraints() {
		dissmissButton.pin(.fixedHeight(30), .fixedHeight(30), .top(padding: 22), .trailing(padding: 0))
		clearNavigationBar.pin(.horizontalEdges(padding: 0), .top(padding: 0))
		statusIconView.pin(.fixedWidth(56), .fixedHeight(56))
		statusInfoStackView.pin(.centerY(padding: -68), .horizontalEdges(to: layoutMarginsGuide, padding: 16))
		closeButton.pin(.bottom(padding: 32), .horizontalEdges(padding: 16))
	}

	private func setupBindings() {
		sendStatusVM.$sendTransactionStatus.sink { sendTransactionStatus in
			self.updateViewWithPageStatus(pageStatus: sendTransactionStatus)
		}.store(in: &cancellables)
	}

	private func updateViewWithPageStatus(pageStatus: SendTransactionStatus) {
		self.pageStatus = pageStatus
		switch pageStatus {
		case .pending:
			statusInfoStackView.isHidden = false
			loading.isHidden = false
			statusIconView.isHidden = true
			dissmissButton.isHidden = false
			toggleIsModalInPresentation(false)
			closeButton.isHidden = false
			statusTitleLabel.text = sendStatusVM.confirmingTitleText
			statusDescriptionLabel.text = sendStatusVM.confirmingDescriptionText
		case .success:
			statusIconView.image = UIImage(named: sendStatusVM.sentIconName)
			statusTitleLabel.text = sendStatusVM.transactionSentText
			statusDescriptionLabel.text = sendStatusVM.transactionSentInfoText
			setupAdditionalSettingsForLabels()
			loading.isHidden = true
			statusIconView.isHidden = false
			statusInfoStackView.isHidden = false
			dissmissButton.isHidden = false
			toggleIsModalInPresentation(false)
			closeButton.isHidden = false
		case .failed:
			statusIconView.image = UIImage(named: sendStatusVM.failedIconName)
			statusTitleLabel.text = sendStatusVM.somethingWentWrongText
			statusDescriptionLabel.text = sendStatusVM.tryAgainLaterText
			setupAdditionalSettingsForLabels()
			loading.isHidden = true
			statusIconView.isHidden = false
			statusInfoStackView.isHidden = false
			dissmissButton.isHidden = false
			toggleIsModalInPresentation(false)
			closeButton.isHidden = false
		case .sending:
			statusInfoStackView.isHidden = false
			loading.isHidden = false
			statusIconView.isHidden = true
			dissmissButton.isHidden = true
			toggleIsModalInPresentation(true)
			closeButton.isHidden = true
			statusTitleLabel.text = sendStatusVM.confirmingTitleText
			statusDescriptionLabel.text = sendStatusVM.confirmingDescriptionText
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
        hapticManager.run(type: .mediumImpact)
		onDissmiss(pageStatus)
	}
    @objc
    private func onDissmissNavigationTap() {
        hapticManager.run(type: .lightImpact)
        onDissmiss(pageStatus)
    }

	@objc
	private func openViewStatusURL() {
		let viewStatusUrl = URL(string: txHash.ethScanTxURL)
		UIApplication.shared.open(viewStatusUrl!)
	}
}
