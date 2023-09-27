//
//  BorrowConfirmView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/2/23.
//

import Kingfisher
import UIKit

class BorrowConfirmView: UIView {
	// MARK: - TypeAliases

	typealias presentActionSheetClosureType = (_ actionSheet: InfoActionSheet) -> Void

	// MARK: - Closures

	public var presentActionSheetClosure: presentActionSheetClosureType

	// MARK: - Private Properties

	private let mainStackView = UIStackView()
	private let headerContainerView = PinoContainerCard()
	private let headerStackView = UIStackView()
	private let headerImageView = UIImageView()
	private let headerInfoStackView = UIStackView()
	private let headerTitleLabel = PinoLabel(style: .title, text: "")
	private let headerDescriptionLabel = PinoLabel(style: .info, text: "")
	private let infoContainerView = PinoContainerCard()
	private let infoStackView = UIStackView()
	private let feeInfoStackView = UIStackView()
	private let protocolInfoStackView = UIStackView()
	private let protocolSpacerView = UIView()
	private let feeSpacerView = UIView()
	private let feeLabel = PinoLabel(style: .info, text: "")
	private let confirmButton = PinoButton(style: .active)
	private var borrowConfrimVM: BorrowConfirmViewModel

	private var protocolTitleWithInfo: TitleWithInfo!
	private var feeTitleWithInfo: TitleWithInfo!
	private var protocolInfoView: UserAccountInfoView!

	// MARK: - Initializers

	init(borrowConfirmVM: BorrowConfirmViewModel, presentActionSheetClosure: @escaping presentActionSheetClosureType) {
		self.borrowConfrimVM = borrowConfirmVM
		self.presentActionSheetClosure = presentActionSheetClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		protocolTitleWithInfo = TitleWithInfo(
			actionSheetTitle: borrowConfrimVM.protocolTitle,
			actionSheetDescription: borrowConfrimVM.protocolActionsheetText
		)
		protocolTitleWithInfo.presentActionSheet = { actionSheet in
			self.presentActionSheetClosure(actionSheet)
		}

		feeTitleWithInfo = TitleWithInfo(
			actionSheetTitle: borrowConfrimVM.feeTitle,
			actionSheetDescription: borrowConfrimVM.feeActionSheetText
		)
		feeTitleWithInfo.presentActionSheet = { actionSheet in
			self.presentActionSheetClosure(actionSheet)
		}

		protocolInfoView = UserAccountInfoView(
			image: borrowConfrimVM.protocolImageName,
			title: borrowConfrimVM.protocolName
		)

		protocolInfoStackView.addArrangedSubview(protocolTitleWithInfo)
		protocolInfoStackView.addArrangedSubview(protocolSpacerView)
		protocolInfoStackView.addArrangedSubview(protocolInfoView)

		feeInfoStackView.addArrangedSubview(feeTitleWithInfo)
		feeInfoStackView.addArrangedSubview(feeSpacerView)
		feeInfoStackView.addArrangedSubview(feeLabel)

		infoStackView.addArrangedSubview(protocolInfoStackView)
		infoStackView.addArrangedSubview(feeInfoStackView)

		infoContainerView.addSubview(infoStackView)

		headerInfoStackView.addArrangedSubview(headerTitleLabel)
		headerInfoStackView.addArrangedSubview(headerDescriptionLabel)

		headerStackView.addArrangedSubview(headerImageView)
		headerStackView.addArrangedSubview(headerInfoStackView)

		headerContainerView.addSubview(headerStackView)

		mainStackView.addArrangedSubview(headerContainerView)
		mainStackView.addArrangedSubview(infoContainerView)

		addSubview(mainStackView)
		addSubview(confirmButton)
	}

	private func setupStyles() {
		backgroundColor = .Pino.background

		mainStackView.axis = .vertical
		mainStackView.spacing = 16

		headerStackView.axis = .vertical
		headerStackView.spacing = 16
		headerStackView.alignment = .center

		headerInfoStackView.axis = .vertical
		headerInfoStackView.spacing = 4
		headerInfoStackView.alignment = .center

		infoStackView.axis = .vertical
		infoStackView.spacing = 22

		protocolInfoStackView.axis = .horizontal
		protocolInfoStackView.alignment = .center

		feeInfoStackView.axis = .horizontal
		feeInfoStackView.alignment = .center

		headerImageView.kf.indicatorType = .activity
		headerImageView.kf.setImage(with: borrowConfrimVM.tokenImage)

		headerTitleLabel.font = .PinoStyle.semiboldTitle2
		headerTitleLabel.text = borrowConfrimVM.tokenAmountAndSymbol
		headerTitleLabel.numberOfLines = 0

		headerDescriptionLabel.textColor = .Pino.secondaryLabel
		headerDescriptionLabel.text = borrowConfrimVM.tokenAmountInDollars
		headerDescriptionLabel.numberOfLines = 0

		protocolTitleWithInfo.title = borrowConfrimVM.protocolTitle

		feeTitleWithInfo.title = borrowConfrimVM.feeTitle

		feeLabel.text = borrowConfrimVM.fee

		confirmButton.title = borrowConfrimVM.confirmButtonTitle
	}

	private func setupConstraints() {
		headerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		headerDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		protocolInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		feeInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

		mainStackView.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.top(to: layoutMarginsGuide, padding: 24)
		)
		headerStackView.pin(.verticalEdges(padding: 16), .horizontalEdges(padding: 10))
		headerImageView.pin(.fixedWidth(50), .fixedHeight(50))
		infoStackView.pin(.horizontalEdges(padding: 10), .verticalEdges(padding: 20))
		confirmButton.pin(
			.horizontalEdges(to: layoutMarginsGuide, padding: 0),
			.bottom(to: layoutMarginsGuide, padding: 12)
		)
	}
}
