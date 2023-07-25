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

	typealias PresentActionSheetType = (_ actionSheet: InfoActionSheet) -> Void

	// MARK: - Closures

	public var presentActionSheet: PresentActionSheetType

	// MARK: - Private Properties

	private let containerView = PinoContainerCard()
	private let betweenView = UIView()
	private let mainStackView = UIStackView()
	private let statusLabelContainer = UIView()
	private let statusInfoLabel = UILabel()
	private let dateLabel = PinoLabel(style: .info, text: "")
	private let feeLabel = PinoLabel(style: .info, text: "")
	private let fromAddressLabel = PinoLabel(style: .info, text: "")
	private let toAddressLabel = PinoLabel(style: .info, text: "")
	private var dateStackView: ActivityInfoStackView!
	private var statusStackView: ActivityInfoStackView!
	private var fromStackView: ActivityInfoStackView!
	private var toStackView: ActivityInfoStackView!
	private var protocolStackView: ActivityInfoStackView!
	private var typeStackView: ActivityInfoStackView!
	private var feeStackView: ActivityInfoStackView!
	private var cancellables = Set<AnyCancellable>()

    private var activityDetailsVM: ActivityDetailsViewModel

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

		let copyFromAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyFromAddress))
		fromAddressLabel.addGestureRecognizer(copyFromAddressGesture)
		fromAddressLabel.isUserInteractionEnabled = true

		let copyToAddressGesture = UITapGestureRecognizer(target: self, action: #selector(copyToAddress))
		toAddressLabel.addGestureRecognizer(copyToAddressGesture)
		toAddressLabel.isUserInteractionEnabled = true

		let toggleFeeGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFee))
		feeLabel.addGestureRecognizer(toggleFeeGesture)
		feeLabel.isUserInteractionEnabled = true

		let toggleDateGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDate))
		dateLabel.addGestureRecognizer(toggleDateGesture)
		dateLabel.isUserInteractionEnabled = true

		dateStackView = ActivityInfoStackView(title: activityDetailsVM.dateTitle, infoCustomView: dateLabel)
		statusStackView = ActivityInfoStackView(
			title: activityDetailsVM.statusTitle,
			actionSheetInfo: (
				title: activityDetailsVM.statusTitle,
				description: activityDetailsVM.statusActionSheetText,
				show: true
			),
			infoCustomView: statusLabelContainer
		)
        toStackView = ActivityInfoStackView(title: activityDetailsVM.toTitle, info: activityDetailsVM.properties.toAddress)
		typeStackView = ActivityInfoStackView(
			title: activityDetailsVM.typeTitle,
            info: activityDetailsVM.properties.typeName,
			actionSheetInfo: (
				title: activityDetailsVM.typeTitle,
				description: activityDetailsVM.typeActionSheetText,
				show: true
			)
		)
		feeStackView = ActivityInfoStackView(
			title: activityDetailsVM.feeTitle,
			actionSheetInfo: (
				title: activityDetailsVM.feeTitle,
				description: activityDetailsVM.feeActionSheetText,
				show: true
			), infoCustomView: feeLabel
		)

        if activityDetailsVM.properties.uiType == .send {
			fromStackView = ActivityInfoStackView(
				title: activityDetailsVM.fromTitle,
				infoCustomView: ImageAndTitleStackView(
                    image: activityDetailsVM.properties.fromIcon,
                    title: activityDetailsVM.properties.fromName
				)
			)
			toStackView = ActivityInfoStackView(title: activityDetailsVM.toTitle, infoCustomView: toAddressLabel)
        } else if activityDetailsVM.properties.uiType == .receive {
			toStackView = ActivityInfoStackView(
				title: activityDetailsVM.toTitle,
				infoCustomView: ImageAndTitleStackView(
                    image: activityDetailsVM.properties.toIcon,
                    title: activityDetailsVM.properties.toName
				)
			)
			fromStackView = ActivityInfoStackView(
				title: activityDetailsVM.fromTitle,
				infoCustomView: fromAddressLabel
			)
		} else {
			fromStackView = ActivityInfoStackView(
				title: activityDetailsVM.fromTitle,
				infoCustomView: fromAddressLabel
			)
			toStackView = ActivityInfoStackView(title: activityDetailsVM.toTitle, infoCustomView: toAddressLabel)
		}

        if activityDetailsVM.properties.uiType == .swap {
			protocolStackView = ActivityInfoStackView(
				title: activityDetailsVM.providerTitle,
				infoCustomView: ImageAndTitleStackView(
                    image: activityDetailsVM.properties.protocolImage,
                    title: activityDetailsVM.properties.protocolName
				)
			)
		} else {
			protocolStackView = ActivityInfoStackView(
				title: activityDetailsVM.protocolTitle,
				infoCustomView: ImageAndTitleStackView(
                    image: activityDetailsVM.properties.protocolImage,
                    title: activityDetailsVM.properties.protocolName
				)
			)
		}

		statusStackView.presentActionSheet = { [weak self] actionSheet in
			self?.presentActionSheet(actionSheet)
		}
		typeStackView.presentActionSheet = { [weak self] actionSheet in
			self?.presentActionSheet(actionSheet)
		}
		feeStackView.presentActionSheet = { [weak self] actionSheet in
			self?.presentActionSheet(actionSheet)
		}

		mainStackView.addArrangedSubview(dateStackView)
		mainStackView.addArrangedSubview(statusStackView)
		mainStackView.addArrangedSubview(protocolStackView)
		mainStackView.addArrangedSubview(typeStackView)
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

		setValues()

        switch activityDetailsVM.properties.uiType {
		case .swap:
			hideFromAndToStackView()
		case .borrow:
			hideFromAndToStackView()
		case .send, .receive:
			hidePrtocolAndTypeStackView()
		case .unknown:
			protocolStackView.isHidden = true
			hideFromAndToStackView()
		case .collateral:
			hideFromAndToStackView()
		case .un_collateral:
			hideFromAndToStackView()
		case .invest:
			hideFromAndToStackView()
		case .repay:
			hideFromAndToStackView()
		case .withdraw:
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
		typeStackView.isHidden = true
	}

	private func copyString(string: String, toastTitle: String) {
		let pasteboard = UIPasteboard.general
		pasteboard.string = string
		Toast.default(title: toastTitle, style: .copy).show(haptic: .success)
	}

	private func setValues() {
        fromAddressLabel.text = activityDetailsVM.properties.fromAddress

        toAddressLabel.text = activityDetailsVM.properties.toAddress

        feeLabel.text = activityDetailsVM.properties.formattedFeeInDollar

        dateLabel.text = activityDetailsVM.properties.formattedDate

        typeStackView.info = activityDetailsVM.properties.typeName

        switch activityDetailsVM.properties.status {
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
        statusInfoLabel.text = activityDetailsVM.properties.status.description

        if activityDetailsVM.properties.uiType == .send {
			fromStackView.infoCustomView = ImageAndTitleStackView(
                image: activityDetailsVM.properties.fromIcon,
                title: activityDetailsVM.properties.fromName
			)
        } else if activityDetailsVM.properties.uiType == .receive {
			toStackView.infoCustomView = ImageAndTitleStackView(
                image: activityDetailsVM.properties.toIcon,
                title: activityDetailsVM.properties.toName
			)
		}

        protocolStackView.info = activityDetailsVM.properties.protocolName
	}

	private func setupBindings() {
		activityDetailsVM.$activityDetails.sink { _ in
			self.setValues()
		}.store(in: &cancellables)
	}

	@objc
	private func toggleDate() {
        if dateLabel.text == activityDetailsVM.properties.formattedDate {
            dateLabel.text = activityDetailsVM.properties.fullFormattedDate
		} else {
            dateLabel.text = activityDetailsVM.properties.formattedDate
		}
	}

	@objc
	private func toggleFee() {
        if feeLabel.text == activityDetailsVM.properties.formattedFeeInDollar {
            feeLabel.text = activityDetailsVM.properties.formattedFeeInETH
		} else {
            feeLabel.text = activityDetailsVM.properties.formattedFeeInDollar
		}
	}

	@objc
	private func copyFromAddress() {
        copyString(string: activityDetailsVM.properties.fullFromAddress!, toastTitle: activityDetailsVM.copyFromAddressText)
	}

	@objc
	private func copyToAddress() {
        copyString(string: activityDetailsVM.properties.fullToAddress!, toastTitle: activityDetailsVM.copyToAddressText)
	}
}
