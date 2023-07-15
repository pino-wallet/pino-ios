//
//  SwapConfirmationView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 7/15/23.
//

import Combine
import UIKit

class SwapConfirmationView: UIView {
	// MARK: - Private Properties

	private let contentStackview = UIStackView()
	private let cardsStackView = UIStackView()
	private let tokenCardView = PinoContainerCard()
	private let sendInfoCardView = PinoContainerCard()
	private let tokenStackView = UIStackView()
	private let tokenImageView = UIImageView()
	private let tokenAmountStackView = UIStackView()
	private let tokenNameLabel = UILabel()
	private let sendAmountLabel = UILabel()
	private let sendInfoStackView = UIStackView()
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
	private let continueButton = PinoButton(style: .active)

	private let swapConfirmationVM: SwapConfirmationViewModel
	private let confirmButtonTapped: () -> Void
	private let presentFeeInfo: (InfoActionSheet) -> Void
	private let retryFeeCalculation: () -> Void
	private var cancellables = Set<AnyCancellable>()
	private var showFeeInDollar = true

	// MARK: - Initializers

	init(
		swapconfirmationVM: SwapConfirmationViewModel,
		confirmButtonTapped: @escaping () -> Void,
		presentFeeInfo: @escaping (InfoActionSheet) -> Void,
		retryFeeCalculation: @escaping () -> Void
	) {
		self.swapConfirmationVM = swapconfirmationVM
		self.confirmButtonTapped = confirmButtonTapped
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

		setSketonable()

		addSubview(contentStackview)
		addSubview(continueButton)
		contentStackview.addArrangedSubview(cardsStackView)
		cardsStackView.addArrangedSubview(tokenCardView)
		cardsStackView.addArrangedSubview(sendInfoCardView)
		tokenCardView.addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenAmountStackView)
		tokenAmountStackView.addArrangedSubview(tokenNameLabel)
		tokenAmountStackView.addArrangedSubview(sendAmountLabel)
		sendInfoCardView.addSubview(sendInfoStackView)
		sendInfoStackView.addArrangedSubview(rateStrackView)
		sendInfoStackView.addArrangedSubview(ProviderStackView)
		sendInfoStackView.addArrangedSubview(feeStackView)
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

		continueButton.addAction(UIAction(handler: { _ in
			self.confirmButtonTapped()
		}), for: .touchUpInside)

		feeTitleView.presentActionSheet = { feeInfoActionSheet in
			self.presentFeeInfo(feeInfoActionSheet)
		}

		let feeRetryTapGesture = UITapGestureRecognizer(target: self, action: #selector(getFee))
		feeErrorStackView.addGestureRecognizer(feeRetryTapGesture)
	}

	private func setupStyle() {
		tokenNameLabel.text = "Amount"
		sendAmountLabel.text = "AmountInDollar"
		providerTitleLabel.text = swapConfirmationVM.selectedProtocolTitle
		providerNameLabel.text = swapConfirmationVM.selectedProtocolName
		rateTitleLabel.text = swapConfirmationVM.swapRateTitle
		feeTitleView.title = swapConfirmationVM.feeTitle
		continueButton.title = swapConfirmationVM.confirmButtonTitle
		rateLabel.text = swapConfirmationVM.swapRate
		feeErrorLabel.text = swapConfirmationVM.feeErrorText
		feeErrorIcon.image = UIImage(named: swapConfirmationVM.feeErrorIcon)

		providerImageView.image = UIImage(named: swapConfirmationVM.selectedProtocolImage)

		tokenNameLabel.font = .PinoStyle.semiboldTitle2
		sendAmountLabel.font = .PinoStyle.mediumBody
		providerTitleLabel.font = .PinoStyle.mediumBody
		providerNameLabel.font = .PinoStyle.mediumBody
		rateTitleLabel.font = .PinoStyle.mediumBody
		rateLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		feeErrorLabel.font = .PinoStyle.mediumBody

		tokenNameLabel.textColor = .Pino.label
		sendAmountLabel.textColor = .Pino.secondaryLabel
		providerTitleLabel.textColor = .Pino.secondaryLabel
		providerNameLabel.textColor = .Pino.label
		rateTitleLabel.textColor = .Pino.secondaryLabel
		rateLabel.textColor = .Pino.label
		feeLabel.textColor = .Pino.label
		feeErrorLabel.textColor = .Pino.red
		feeErrorIcon.tintColor = .Pino.red

		backgroundColor = .Pino.background

		feeLabel.textAlignment = .right
		rateLabel.textAlignment = .right

		tokenStackView.axis = .vertical
		tokenAmountStackView.axis = .vertical
		cardsStackView.axis = .vertical
		sendInfoStackView.axis = .vertical
		contentStackview.axis = .vertical

		tokenStackView.alignment = .center
		tokenAmountStackView.alignment = .center

		contentStackview.spacing = 24
		cardsStackView.spacing = 18
		tokenStackView.spacing = 16
		tokenAmountStackView.spacing = 10
		sendInfoStackView.spacing = 26
		providerInfoStackView.spacing = 4
		feeErrorStackView.spacing = 4

		tokenImageView.layer.cornerRadius = 25
		tokenImageView.layer.masksToBounds = true

		showSkeletonView()
		continueButton.style = .deactive
		feeErrorStackView.isHidden = true
	}

	private func setupContstraint() {
		contentStackview.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 25)
		)
		tokenStackView.pin(
			.allEdges(padding: 16)
		)
		sendInfoStackView.pin(
			.horizontalEdges(padding: 14),
			.verticalEdges(padding: 24)
		)
		continueButton.pin(
			.bottom(to: layoutMarginsGuide, padding: 8),
			.horizontalEdges(padding: 16)
		)
		tokenImageView.pin(
			.fixedWidth(50),
			.fixedHeight(50)
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
			.fixedWidth(48)
		)
		feeLabel.pin(
			.allEdges
		)
		feeErrorStackView.pin(
			.allEdges
		)

		feeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
	}

	private func setupBindings() {
		Publishers.Zip(swapConfirmationVM.$formattedFeeInDollar, swapConfirmationVM.$formattedFeeInETH)
			.sink { [weak self] feeInDollar, feeInETH in
				guard let self, let feeInETH, let feeInDollar else { return }
				self.hideSkeletonView()
				self.updateFeeLabel(feeInETH: feeInETH, feeInDollar: feeInDollar)
				self.checkBalanceEnough()
			}.store(in: &cancellables)
	}

	private func checkBalanceEnough() {
		if swapConfirmationVM.checkEnoughBalance() {
			continueButton.style = .active
			continueButton.setTitle(swapConfirmationVM.confirmButtonTitle, for: .normal)
		} else {
			continueButton.style = .deactive
			continueButton.setTitle(swapConfirmationVM.insufficientTitle, for: .normal)
		}
	}

	private func setSketonable() {
		feeLabel.isSkeletonable = true
	}

	private func updateFeeLabel(feeInETH: String, feeInDollar: String) {
		if showFeeInDollar {
			feeLabel.text = feeInDollar
		} else {
			feeLabel.text = feeInETH
		}
	}

	@objc
	private func toggleShowFee() {
		showFeeInDollar.toggle()
		updateFeeLabel(
			feeInETH: swapConfirmationVM.formattedFeeInETH!,
			feeInDollar: swapConfirmationVM.formattedFeeInDollar!
		)
	}

	@objc
	private func getFee() {
		retryFeeCalculation()
	}

	// MARK: - Public Methods

	public func showfeeCalculationError() {
		feeLabel.isHidden = true
		feeErrorStackView.isHidden = false
	}

	public func hideFeeCalculationError() {
		feeErrorStackView.isHidden = true
		feeLabel.isHidden = false
	}
}
