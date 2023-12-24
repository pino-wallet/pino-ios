//
//  CollateralConfirmView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 9/3/23.
//

import Combine
import Kingfisher
import UIKit

class CollateralConfirmView: UIView {
	// MARK: - TypeAliases

	typealias presentActionSheetClosureType = (_ actionSheet: InfoActionSheet, _ completion: @escaping () -> Void)
		-> Void

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
	private var collateralConfrimVM: CollateralConfirmViewModel
	private var feeInfo: CollateralConfirmViewModel.FeeInfoType?

	private var protocolTitleWithInfo: TitleWithInfo!
	private var feeTitleWithInfo: TitleWithInfo!
	private var protocolInfoView: UserAccountInfoView!
	private var cancellables = Set<AnyCancellable>()
	private var pageStatus: PageStatus = .loading {
		didSet {
			updateUIWithPageStatus()
		}
	}

	private enum PageStatus {
		case loading
		case notEnough
		case normal
	}

	// MARK: - Initializers

	init(
		collateralConfrimVM: CollateralConfirmViewModel,
		presentActionSheetClosure: @escaping presentActionSheetClosureType
	) {
		self.collateralConfrimVM = collateralConfrimVM
		self.presentActionSheetClosure = presentActionSheetClosure

		super.init(frame: .zero)

		setupView()
		setupStyles()
		setupConstraints()
		setupBindings()
		setupSkeletonLoading()
		updateUIWithPageStatus()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		protocolTitleWithInfo = TitleWithInfo(
			actionSheetTitle: collateralConfrimVM.protocolTitle,
			actionSheetDescription: collateralConfrimVM.protocolActionsheetText
		)
		protocolTitleWithInfo.presentActionSheet = { actionSheet, completion in
			self.presentActionSheetClosure(actionSheet, completion)
		}

		feeTitleWithInfo = TitleWithInfo(
			actionSheetTitle: collateralConfrimVM.feeTitle,
			actionSheetDescription: collateralConfrimVM.feeActionSheetText
		)
		feeTitleWithInfo.presentActionSheet = { actionSheet, completion in
			self.presentActionSheetClosure(actionSheet, completion)
		}

		protocolInfoView = UserAccountInfoView(
			image: collateralConfrimVM.protocolImageName,
			title: collateralConfrimVM.protocolName
		)

		let onConfirmTapGesture = UITapGestureRecognizer(target: self, action: #selector(onConfirm))
		confirmButton.addGestureRecognizer(onConfirmTapGesture)

		let toggleFeeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFeeText))
		feeLabel.addGestureRecognizer(toggleFeeGestureRecognizer)
		feeLabel.isUserInteractionEnabled = true

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
		headerImageView.kf.setImage(with: collateralConfrimVM.tokenImage)

		headerTitleLabel.font = .PinoStyle.semiboldTitle2
		headerTitleLabel.text = collateralConfrimVM.tokenAmountAndSymbol
		headerTitleLabel.numberOfLines = 0

		headerDescriptionLabel.textColor = .Pino.secondaryLabel
		headerDescriptionLabel.text = collateralConfrimVM.tokenAmountInDollars
		headerDescriptionLabel.numberOfLines = 0

		protocolTitleWithInfo.title = collateralConfrimVM.protocolTitle

		feeTitleWithInfo.title = collateralConfrimVM.feeTitle
	}

	private func setupConstraints() {
		headerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
		headerDescriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		protocolInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		feeInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
		feeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
		feeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true

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

	private func setupSkeletonLoading() {
		feeLabel.isSkeletonable = true
	}

	private func setupBindings() {
		collateralConfrimVM.$feeInfo.sink { feeInfo in
			self.feeInfo = feeInfo
			self.feeLabel.text = feeInfo?.feeInDollars
			self.hideSkeletonView()
			self.validateFee(bigNumberFee: feeInfo?.bigNumberFee)
		}.store(in: &cancellables)
	}

	private func validateFee(bigNumberFee: BigNumber?) {
		guard let ethToken = GlobalVariables.shared.manageAssetsList?.first(where: { $0.isEth }),
		      let bigNumberFee else {
			return
		}
		if ethToken.holdAmount >= bigNumberFee {
			pageStatus = .normal
		} else {
			pageStatus = .notEnough
		}
	}

	private func updateUIWithPageStatus() {
		switch pageStatus {
		case .loading:
			confirmButton.style = .deactive
			confirmButton.title = collateralConfrimVM.loadingButtonTitle
		case .notEnough:
			confirmButton.style = .deactive
			confirmButton.title = collateralConfrimVM.insufficientAmountButtonTitle
			if Environment.current != .mainNet {
				confirmButton.style = .active
			}
		case .normal:
			confirmButton.style = .active
			confirmButton.title = collateralConfrimVM.confirmButtonTitle
		}
	}

	@objc
	private func onConfirm() {
		collateralConfrimVM.confirmCollateral()
	}

	@objc
	private func toggleFeeText() {
		if feeLabel.text == feeInfo?.feeInDollars {
			feeLabel.text = feeInfo?.feeInETH
		} else {
			feeLabel.text = feeInfo?.feeInDollars
		}
	}
}
