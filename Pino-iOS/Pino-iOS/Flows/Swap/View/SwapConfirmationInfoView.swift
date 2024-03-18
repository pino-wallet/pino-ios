//
//  SwapConfirmationHeader.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import Combine
import UIKit

class SwapConfirmationInfoView: UIView {
	// MARK: - TypeAliases

	typealias PresentFeeInfoType = (InfoActionSheet, _ completion: @escaping () -> Void) -> Void

	// MARK: - Private Properties

	private let swapInfoStackView = UIStackView()
	private let ProviderStackView = UIStackView()
	private let rateStrackView = UIStackView()
	private let feeStackView = UIStackView()
	private let providerTitleLabel = UILabel()
	private let rateTitleLabel = UILabel()
	private var feeTitleView: TitleWithInfo!
	private let providerInfoStackView = UIStackView()
	private let rateLabel = UILabel()
	private let providerImageView = UIImageView()
	private let providerNameLabel = UILabel()
	private let providerSpacerView = UIView()
	private let rateSpacerView = UIView()
	private let feeSpacerView = UIView()
	private let feeResultView = UIView()
	private let feeErrorIcon = UIImageView()
	private let feeErrorLabel = UILabel()
	private let feeErrorStackView = UIStackView()
	private let feeLabel = UILabel()

	private let swapConfirmationVM: SwapConfirmationViewModel
	private let presentFeeInfo: PresentFeeInfoType
	private let retryFeeCalculation: () -> Void
	private var cancellables = Set<AnyCancellable>()
	private var showFeeInDollar = true

	// MARK: - Initializers

	init(
		swapConfirmationVM: SwapConfirmationViewModel,
		presentFeeInfo: @escaping PresentFeeInfoType,
		retryFeeCalculation: @escaping () -> Void
	) {
		self.swapConfirmationVM = swapConfirmationVM
		self.presentFeeInfo = presentFeeInfo
		self.retryFeeCalculation = retryFeeCalculation
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		feeTitleView = TitleWithInfo(
			actionSheetTitle: swapConfirmationVM.feeInfoActionSheetTitle,
			actionSheetDescription: swapConfirmationVM.feeInfoActionSheetDescription
		)

		addSubview(swapInfoStackView)
		swapInfoStackView.addArrangedSubview(rateStrackView)
		swapInfoStackView.addArrangedSubview(ProviderStackView)
		swapInfoStackView.addArrangedSubview(feeStackView)
		ProviderStackView.addArrangedSubview(providerTitleLabel)
		ProviderStackView.addArrangedSubview(providerSpacerView)
		ProviderStackView.addArrangedSubview(providerInfoStackView)
		providerInfoStackView.addArrangedSubview(providerImageView)
		providerInfoStackView.addArrangedSubview(providerNameLabel)
		rateStrackView.addArrangedSubview(rateTitleLabel)
		rateStrackView.addArrangedSubview(rateSpacerView)
		rateStrackView.addArrangedSubview(rateLabel)

		feeStackView.addArrangedSubview(feeTitleView)
		feeStackView.addArrangedSubview(feeSpacerView)
		feeStackView.addArrangedSubview(feeResultView)
		feeResultView.addSubview(feeErrorStackView)
		feeResultView.addSubview(feeLabel)
		feeErrorStackView.addArrangedSubview(feeErrorIcon)
		feeErrorStackView.addArrangedSubview(feeErrorLabel)

		let feeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleShowFee))
		feeLabel.addGestureRecognizer(feeLabelTapGesture)
		feeLabel.isUserInteractionEnabled = true

		let feeRetryTapGesture = UITapGestureRecognizer(target: self, action: #selector(getFee))
		feeErrorStackView.addGestureRecognizer(feeRetryTapGesture)

		feeTitleView.presentActionSheet = { feeInfoActionSheet, completion in
			self.presentFeeInfo(feeInfoActionSheet, completion)
		}
	}

	private func setupStyle() {
		providerTitleLabel.text = swapConfirmationVM.selectedProtocolTitle
		providerNameLabel.text = swapConfirmationVM.selectedProtocolName
		rateTitleLabel.text = swapConfirmationVM.swapRateTitle
		feeTitleView.title = swapConfirmationVM.feeTitle
		rateLabel.text = swapConfirmationVM.swapRate
		feeErrorLabel.text = swapConfirmationVM.feeErrorText
		feeErrorIcon.image = UIImage(named: swapConfirmationVM.feeErrorIcon)
		providerImageView.image = UIImage(named: swapConfirmationVM.selectedProtocolImage)

		providerTitleLabel.font = .PinoStyle.mediumBody
		providerNameLabel.font = .PinoStyle.mediumBody
		rateTitleLabel.font = .PinoStyle.mediumBody
		rateLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		feeErrorLabel.font = .PinoStyle.mediumBody

		providerTitleLabel.textColor = .Pino.secondaryLabel
		providerNameLabel.textColor = .Pino.label
		rateTitleLabel.textColor = .Pino.secondaryLabel
		rateLabel.textColor = .Pino.label
		feeLabel.textColor = .Pino.label
		feeErrorLabel.textColor = .Pino.red
		feeErrorIcon.tintColor = .Pino.red

		feeLabel.layer.masksToBounds = true
		feeLabel.textAlignment = .right
		rateLabel.textAlignment = .right

		swapInfoStackView.axis = .vertical

		swapInfoStackView.spacing = 26
		providerInfoStackView.spacing = 4
		feeErrorStackView.spacing = 4

		setSketonable()
		feeErrorStackView.isHidden = true
	}

	private func setupContstraint() {
		swapInfoStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 24)
		)
		providerImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		feeErrorIcon.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		feeTitleView.pin(
			.fixedWidth(120)
		)
		feeLabel.pin(
			.verticalEdges,
			.trailing
		)
		feeErrorStackView.pin(
			.allEdges
		)
        

		NSLayoutConstraint.activate([
			feeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
			feeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: feeResultView.leadingAnchor),
            feeResultView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
		])
	}

	private func setupBindings() {
		swapConfirmationVM.$swapRate.sink { [self] rate in
			guard let rate else { showRateLoading(); return }
			rateLabel.text = rate
			hideRateLoading()
		}.store(in: &cancellables)
	}

	private func setSketonable() {
		feeLabel.isSkeletonable = true
		rateLabel.isSkeletonable = true
	}

	@objc
	private func toggleShowFee() {
		guard let formattedFee = swapConfirmationVM.formattedFeeInETH else { return }
		showFeeInDollar.toggle()
		updateFeeLabel(
			feeInETH: formattedFee,
			feeInDollar: swapConfirmationVM.formattedFeeInDollar!
		)
	}

	@objc
	private func getFee() {
		retryFeeCalculation()
	}

	// MARK: - Public Methods

	public func updateFeeLabel(feeInETH: String, feeInDollar: String) {
		if showFeeInDollar {
			feeLabel.text = feeInDollar
		} else {
			feeLabel.text = feeInETH
		}
	}

	public func updateRateLabel(rate: String) {
		rateLabel.text = rate
	}

	public func showfeeCalculationError() {
		feeLabel.isHidden = true
		feeErrorStackView.isHidden = false
	}

	public func hideFeeCalculationError() {
		feeErrorStackView.isHidden = true
		feeLabel.isHidden = false
	}

	public func showRateLoading() {
		rateStrackView.showSkeletonView()
	}

	public func hideRateLoading() {
		rateStrackView.hideSkeletonView()
	}

	public func showFeeLoading() {
		feeStackView.showSkeletonView()
	}

	public func hideFeeLoading() {
		feeStackView.hideSkeletonView()
	}
}
