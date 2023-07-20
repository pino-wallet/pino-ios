//
//  SendConfimationView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import Combine
import UIKit

class SendConfirmationView: UIView {
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
	private let selectedWalletStackView = UIStackView()
	private let recipientStrackView = UIStackView()
	private let feeStackView = UIStackView()
	private let selectedWalletTitleLabel = UILabel()
	private let recipientTitleLabel = UILabel()
	private var feeTitleView: TitleWithInfo!
	private let walletInfoStackView = UIStackView()
	private let recipientAddressLabel = UILabel()
	private let walletImageBackgroundView = UIView()
	private let walletImageView = UIImageView()
	private let walletNameLabel = UILabel()
	private let scamErrorView = PinoContainerCard()
	private let scamErrorLabel = PinoLabel(style: .description, text: nil)
	private let selectedWalletSpacerView = UIView()
	private let recipientSpacerView = UIView()
	private let feeSpacerView = UIView()
	private let feeResultView = UIView()
	private let feeErrorIcon = UIImageView()
	private let feeErrorLabel = UILabel()
	private let feeErrorStackView = UIStackView()
	private let feeLabel = UILabel()

	private let continueButton = PinoButton(style: .active)
	private let confirmButtonTapped: () -> Void
	private let presentFeeInfo: (InfoActionSheet) -> Void
	private let retryFeeCalculation: () -> Void
	private let sendConfirmationVM: SendConfirmationViewModel
	private var cancellables = Set<AnyCancellable>()
	private var showFeeInDollar = true

	// MARK: - Initializers

	init(
		sendConfirmationVM: SendConfirmationViewModel,
		confirmButtonTapped: @escaping () -> Void,
		presentFeeInfo: @escaping (InfoActionSheet) -> Void,
		retryFeeCalculation: @escaping () -> Void
	) {
		self.sendConfirmationVM = sendConfirmationVM
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
			actionSheetTitle: sendConfirmationVM.feeInfoActionSheetTitle,
			actionSheetDescription: sendConfirmationVM.feeInfoActionSheetDescription
		)

		setSketonable()

		addSubview(contentStackview)
		addSubview(continueButton)
		contentStackview.addArrangedSubview(cardsStackView)
		contentStackview.addArrangedSubview(scamErrorView)
		cardsStackView.addArrangedSubview(tokenCardView)
		cardsStackView.addArrangedSubview(sendInfoCardView)
		tokenCardView.addSubview(tokenStackView)
		tokenStackView.addArrangedSubview(tokenImageView)
		tokenStackView.addArrangedSubview(tokenAmountStackView)
		tokenAmountStackView.addArrangedSubview(tokenNameLabel)
		tokenAmountStackView.addArrangedSubview(sendAmountLabel)
		sendInfoCardView.addSubview(sendInfoStackView)
		sendInfoStackView.addArrangedSubview(selectedWalletStackView)
		sendInfoStackView.addArrangedSubview(recipientStrackView)
		sendInfoStackView.addArrangedSubview(feeStackView)
		selectedWalletStackView.addArrangedSubview(selectedWalletTitleLabel)
		selectedWalletStackView.addArrangedSubview(selectedWalletSpacerView)
		selectedWalletStackView.addArrangedSubview(walletInfoStackView)
		walletInfoStackView.addArrangedSubview(walletImageBackgroundView)
		walletInfoStackView.addArrangedSubview(walletNameLabel)
		walletImageBackgroundView.addSubview(walletImageView)
		recipientStrackView.addArrangedSubview(recipientTitleLabel)
		recipientStrackView.addArrangedSubview(recipientSpacerView)
		recipientStrackView.addArrangedSubview(recipientAddressLabel)

		feeStackView.addArrangedSubview(feeTitleView)
		feeStackView.addArrangedSubview(feeSpacerView)
		feeStackView.addArrangedSubview(feeResultView)
		feeResultView.addSubview(feeErrorStackView)
		feeResultView.addSubview(feeLabel)
		feeErrorStackView.addArrangedSubview(feeErrorIcon)
		feeErrorStackView.addArrangedSubview(feeErrorLabel)

		scamErrorView.addSubview(scamErrorLabel)

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
		tokenNameLabel.text = sendConfirmationVM.formattedSendAmount
		sendAmountLabel.text = sendConfirmationVM.sendAmountInDollar
		selectedWalletTitleLabel.text = sendConfirmationVM.selectedWalletTitle
		walletNameLabel.text = sendConfirmationVM.selectedWalletName
		recipientTitleLabel.text = sendConfirmationVM.recipientAddressTitle
		scamErrorLabel.text = sendConfirmationVM.scamErrorTitle
		feeTitleView.title = sendConfirmationVM.feeTitle
		continueButton.title = sendConfirmationVM.confirmButtonTitle
		recipientAddressLabel.text = sendConfirmationVM.recipientAddress.shortenedString(
			characterCountFromStart: 6,
			characterCountFromEnd: 4
		)
		feeErrorLabel.text = sendConfirmationVM.feeErrorText
		feeErrorIcon.image = UIImage(named: sendConfirmationVM.feeErrorIcon)

		walletImageView.image = UIImage(named: sendConfirmationVM.selectedWalletImage)
		walletImageBackgroundView.backgroundColor = UIColor(named: sendConfirmationVM.selectedWalletImage)

		if sendConfirmationVM.isTokenVerified {
			tokenImageView.kf.indicatorType = .activity
			tokenImageView.kf.setImage(with: sendConfirmationVM.tokenImage)
			sendAmountLabel.isHidden = false
		} else {
			tokenImageView.image = UIImage(named: sendConfirmationVM.customAssetImage)
			sendAmountLabel.isHidden = true
		}

		tokenNameLabel.font = .PinoStyle.semiboldTitle2
		sendAmountLabel.font = .PinoStyle.mediumBody
		selectedWalletTitleLabel.font = .PinoStyle.mediumBody
		walletNameLabel.font = .PinoStyle.mediumBody
		recipientTitleLabel.font = .PinoStyle.mediumBody
		recipientAddressLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody
		feeErrorLabel.font = .PinoStyle.mediumBody
		scamErrorLabel.font = .PinoStyle.mediumCallout

		tokenNameLabel.textColor = .Pino.label
		sendAmountLabel.textColor = .Pino.secondaryLabel
		selectedWalletTitleLabel.textColor = .Pino.secondaryLabel
		walletNameLabel.textColor = .Pino.label
		recipientTitleLabel.textColor = .Pino.secondaryLabel
		recipientAddressLabel.textColor = .Pino.label
		feeLabel.textColor = .Pino.label
		feeErrorLabel.textColor = .Pino.red
		scamErrorLabel.textColor = .Pino.label
		feeErrorIcon.tintColor = .Pino.red

		backgroundColor = .Pino.background
		scamErrorView.backgroundColor = .Pino.lightRed

		feeLabel.textAlignment = .right
		recipientAddressLabel.textAlignment = .right
		scamErrorLabel.numberOfLines = 0

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
		walletInfoStackView.spacing = 4
		feeErrorStackView.spacing = 4

		walletImageBackgroundView.layer.cornerRadius = 10
		tokenImageView.layer.cornerRadius = 25
		tokenImageView.layer.masksToBounds = true

		if sendConfirmationVM.isAddressScam {
			scamErrorView.isHidden = false
			continueButton.title = sendConfirmationVM.scamConfirmButtonTitle
		} else {
			scamErrorView.isHidden = true
			continueButton.title = sendConfirmationVM.confirmButtonTitle
		}
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
		walletImageBackgroundView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		walletImageView.pin(
			.allEdges(padding: 3)
		)
		scamErrorLabel.pin(
			.verticalEdges(padding: 18),
			.horizontalEdges(padding: 16)
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
		Publishers.Zip(sendConfirmationVM.$formattedFeeInDollar, sendConfirmationVM.$formattedFeeInETH)
			.sink { [weak self] formattedFeeDollar, formattedFeeETH in
				self?.hideSkeletonView()
				self?.updateFeeLabel()
				self?.checkBalanceEnough()
			}.store(in: &cancellables)
	}

	private func checkBalanceEnough() {
		if sendConfirmationVM.checkEnoughBalance() {
			continueButton.style = .active
			continueButton.setTitle(sendConfirmationVM.confirmBtnText, for: .normal)
		} else {
			continueButton.style = .deactive
			continueButton.setTitle(sendConfirmationVM.insuffientText, for: .normal)
		}
	}

	private func setSketonable() {
		feeLabel.isSkeletonable = true
	}

	private func updateFeeLabel() {
		if showFeeInDollar {
			feeLabel.text = sendConfirmationVM.formattedFeeInDollar
		} else {
			feeLabel.text = sendConfirmationVM.formattedFeeInETH
		}
	}

	@objc
	private func toggleShowFee() {
		showFeeInDollar.toggle()
		updateFeeLabel()
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
