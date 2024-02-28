//
//  ActivityInfoView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 7/12/23.
//

import Combine
import UIKit

class ActivityInfoView: UIView {
	// MARK: - TypeAliases

	typealias PresentActionSheetType = (_ actionSheet: InfoActionSheet, _ completion: @escaping () -> Void) -> Void

	// MARK: - Closures

	public var presentActionSheet: PresentActionSheetType

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let betweenView = UIView()
	private let mainStackView = UIStackView()
	private let statusLabelContainer = UIView()
	private let statusInfoLabel = UILabel()
	private let feeLabel = PinoLabel(style: .info, text: "")
	private let fromAddressLabel = PinoLabel(style: .info, text: "")
	private let toAddressLabel = PinoLabel(style: .info, text: "")
	private var dateStackView: ActivityInfoStackView!
	private var statusStackView: ActivityInfoStackView!
	private var fromStackView: ActivityInfoStackView!
	private var toStackView: ActivityInfoStackView!
	private var protocolStackView: ActivityInfoStackView!
	private var feeStackView: ActivityInfoStackView!
	private var activityProperties: ActivityDetailProperties!
	private var fromInfoCustomView: ImageAndInfoView!
	private var toInfoCustomView: ImageAndInfoView!
	private var protocolInfoCustomView: ImageAndInfoView!
	private var cancellables = Set<AnyCancellable>()
	private var activityDetailsVM: ActivityDetailsViewModel

	private enum ShowFeeModes {
		case inDollars
		case inETH
	}

	private var showFeeMode: ShowFeeModes = .inDollars

	// MARK: - Initializers

	init(activityDetailsVM: ActivityDetailsViewModel, presentActionSheet: @escaping PresentActionSheetType) {
		self.activityDetailsVM = activityDetailsVM
		self.presentActionSheet = presentActionSheet

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		statusLabelContainer.addSubview(statusInfoLabel)

		fromInfoCustomView = ImageAndInfoView(
			image: nil,
			title: nil
		)
		toInfoCustomView = ImageAndInfoView(
			image: nil,
			title: nil
		)

		protocolInfoCustomView = ImageAndInfoView(
			image: nil,
			title: nil
		)

		let copyFromAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyFromAddress))
		let copyToAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyToAddress))
		let copyCustomFromAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyFromAddress))
		let copyCustomToAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyToAddress))

		fromAddressLabel.addGestureRecognizer(copyFromAddressGesture)
		fromAddressLabel.isUserInteractionEnabled = true

		fromInfoCustomView.addGestureRecognizer(copyCustomFromAddressGesture)
		fromInfoCustomView.isUserInteractionEnabled = true

		toAddressLabel.addGestureRecognizer(copyToAddressGesture)
		toAddressLabel.isUserInteractionEnabled = true

		toInfoCustomView.addGestureRecognizer(copyCustomToAddressGesture)
		toInfoCustomView.isUserInteractionEnabled = true

		let toggleFeeGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFee))
		feeLabel.addGestureRecognizer(toggleFeeGesture)
		feeLabel.isUserInteractionEnabled = true

		dateStackView = ActivityInfoStackView(title: activityDetailsVM.dateTitle)
		statusStackView = ActivityInfoStackView(
			title: activityDetailsVM.statusTitle,
			actionSheetInfo: (
				title: activityDetailsVM.statusTitle,
				description: activityDetailsVM.statusActionSheetText,
				show: true
			),
			infoCustomView: statusLabelContainer
		)
		toStackView = ActivityInfoStackView(
			title: activityDetailsVM.toTitle
		)
		feeStackView = ActivityInfoStackView(
			title: activityDetailsVM.feeTitle,
			actionSheetInfo: (
				title: activityDetailsVM.feeTitle,
				description: activityDetailsVM.feeActionSheetText,
				show: true
			), infoCustomView: feeLabel
		)

		if activityDetailsVM.properties.userFromAccountInfo != nil && activityDetailsVM.properties.uiType == .receive {
			fromStackView = ActivityInfoStackView(
				title: activityDetailsVM.fromTitle,
				infoCustomView: fromInfoCustomView
			)
		} else {
			fromStackView = ActivityInfoStackView(
				title: activityDetailsVM.fromTitle,
				infoCustomView: fromAddressLabel
			)
		}

		if activityDetailsVM.properties.userToAccountInfo != nil && activityDetailsVM.properties.uiType == .send {
			toStackView = ActivityInfoStackView(
				title: activityDetailsVM.toTitle,
				infoCustomView: toInfoCustomView
			)
		} else {
			toStackView = ActivityInfoStackView(title: activityDetailsVM.toTitle, infoCustomView: toAddressLabel)
		}

		if activityDetailsVM.properties.uiType == .swap {
			protocolStackView = ActivityInfoStackView(
				title: activityDetailsVM.providerTitle,
				infoCustomView: protocolInfoCustomView
			)
		} else {
			protocolStackView = ActivityInfoStackView(
				title: activityDetailsVM.protocolTitle,
				infoCustomView: protocolInfoCustomView
			)
		}

		statusStackView.presentActionSheet = { [weak self] actionSheet, completion in
			self?.presentActionSheet(actionSheet, completion)
		}
		feeStackView.presentActionSheet = { [weak self] actionSheet, completion in
			self?.presentActionSheet(actionSheet, completion)
		}

		mainStackView.addArrangedSubview(dateStackView)
		mainStackView.addArrangedSubview(statusStackView)
		mainStackView.addArrangedSubview(protocolStackView)
		mainStackView.addArrangedSubview(fromStackView)
		mainStackView.addArrangedSubview(toStackView)
		mainStackView.addArrangedSubview(feeStackView)

		containerView.addSubview(mainStackView)

		addSubview(containerView)
	}

	private func setupStyles() {
		mainStackView.axis = .vertical
		mainStackView.spacing = 22

		statusInfoLabel.font = .PinoStyle.semiboldSubheadline

		statusLabelContainer.layer.cornerRadius = 14
		statusLabelContainer.layer.masksToBounds = true

		if activityDetailsVM.properties.protocolName == nil {
			protocolStackView.isHidden = true
		}

		switch activityDetailsVM.properties.uiType {
		case .swap:
			hideFromAndToStackView()
//		case .borrow:
//			hideFromAndToStackView()
		case .send:
			hidePrtocolAndTypeStackView()
			fromStackView.isHidden = true
		case .receive:
			hidePrtocolAndTypeStackView()
			toStackView.isHidden = true
		case .invest:
			hideFromAndToStackView()
//		case .repay:
//			hideFromAndToStackView()
		case .withdraw_investment:
			hideFromAndToStackView()
		case .collateral:
			hideFromAndToStackView()
//		case .withdraw_collateral:
//			hideFromAndToStackView()
//		case .enable_collateral:
//			hideFromAndToStackView()
//		case .disable_collateral:
//			hideFromAndToStackView()
		case .approve:
			hideFromAndToStackView()
		case .wrapETH, .unwrapETH:
			hidePrtocolAndTypeStackView()
			hideFromAndToStackView()
		}
	}

	private func setupConstraints() {
		containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true

		statusLabelContainer.pin(.fixedHeight(28))

		statusInfoLabel.pin(.horizontalEdges(padding: 10), .centerY)

		containerView.pin(.allEdges(padding: 0))
		mainStackView.pin(.horizontalEdges(padding: 14), .verticalEdges(padding: 24))
	}

	private func hideFromAndToStackView() {
		fromStackView.isHidden = true
		toStackView.isHidden = true
	}

	private func hidePrtocolAndTypeStackView() {
		protocolStackView.isHidden = true
	}

	private func copyString(string: String) {
		let pasteboard = UIPasteboard.general
		pasteboard.string = string
		Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
	}

	private func setValues() {
		fromAddressLabel.text = activityProperties.fromAddress

		toAddressLabel.text = activityProperties.toAddress

		switch showFeeMode {
		case .inDollars:
			feeLabel.text = activityProperties.formattedFeeInDollar
		case .inETH:
			feeLabel.text = activityProperties.formattedFeeInETH
		}

		dateStackView.info = activityProperties.formattedDate

		switch activityProperties.status {
		case .complete:
			statusInfoLabel.textColor = .Pino.green3
			statusLabelContainer.backgroundColor = .Pino.green1
		case .failed:
			statusInfoLabel.textColor = .Pino.red
			statusLabelContainer.backgroundColor = .Pino.lightRed
		case .pending:
			statusInfoLabel.textColor = .Pino.pendingOrange
			statusLabelContainer.backgroundColor = .Pino.lightOrange
		}
		statusInfoLabel.text = activityProperties.status.description
		statusInfoLabel.textAlignment = .center

		if activityDetailsVM.properties.userFromAccountInfo != nil {
			fromInfoCustomView.image = activityDetailsVM.properties.userFromAccountInfo?.image
			fromInfoCustomView.title = activityDetailsVM.properties.userFromAccountInfo?.name
		}
		if activityDetailsVM.properties.userToAccountInfo != nil {
			toInfoCustomView.image = activityDetailsVM.properties.userToAccountInfo?.image
			toInfoCustomView.title = activityDetailsVM.properties.userToAccountInfo?.name
		}

		protocolInfoCustomView.title = activityProperties.protocolName
		protocolInfoCustomView.image = activityProperties.protocolImage
	}

	private func setupBindings() {
		activityDetailsVM.$properties.sink { activityProperties in
			self.activityProperties = activityProperties
			self.setValues()
		}.store(in: &cancellables)
	}

	@objc
	private func toggleFee() {
		if feeLabel.text == activityProperties.formattedFeeInDollar {
			feeLabel.text = activityProperties.formattedFeeInETH
			showFeeMode = .inETH
		} else {
			feeLabel.text = activityProperties.formattedFeeInDollar
			showFeeMode = .inDollars
		}
	}

	@objc
	private func copyFromAddress() {
		copyString(
			string: activityProperties.fullFromAddress!
		)
	}

	@objc
	private func copyToAddress() {
		copyString(string: activityProperties.fullToAddress!)
	}
}
