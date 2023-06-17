//
//  SendConfimationView.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import UIKit

class SendConfirmationView: UIView {
	// MARK: - Private Properties

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
	private let feeStrackView = UIStackView()

	private let selectedWalletTitleLabel = UILabel()
	private let recipientTitleLabel = UILabel()
	private let feeTitleView = TitleWithInfo(actionSheetTitle: "", actionSheetDescription: "")

	private let walletInfoStackView = UIStackView()
	private let recipientAddressLabel = UILabel()
	private let feeLabel = UILabel()

	private let walletImageBackgroundView = UIView()
	private let walletImageView = UIImageView()
	private let walletNameLabel = UILabel()

	private let continueButton = PinoButton(style: .active)
	private var confirmButtonTapped: () -> Void
	private let sendConfirmationVM: SendConfirmationViewModel

	// MARK: - Initializers

	init(
		sendConfirmationVM: SendConfirmationViewModel,
		confirmButtonTapped: @escaping (() -> Void)
	) {
		self.sendConfirmationVM = sendConfirmationVM
		self.confirmButtonTapped = confirmButtonTapped
		super.init(frame: .zero)
		setupView()
		setupStyle()
		setupContstraint()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	// MARK: - Private Methods

	private func setupView() {
		addSubview(cardsStackView)
		addSubview(continueButton)
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
		sendInfoStackView.addArrangedSubview(feeStrackView)
		selectedWalletStackView.addArrangedSubview(selectedWalletTitleLabel)
		selectedWalletStackView.addArrangedSubview(walletInfoStackView)
		walletInfoStackView.addArrangedSubview(walletImageBackgroundView)
		walletInfoStackView.addArrangedSubview(walletNameLabel)
		walletImageBackgroundView.addSubview(walletImageView)
		recipientStrackView.addArrangedSubview(recipientTitleLabel)
		recipientStrackView.addArrangedSubview(recipientAddressLabel)
		feeStrackView.addArrangedSubview(feeTitleView)
		feeStrackView.addArrangedSubview(feeLabel)

		continueButton.addAction(UIAction(handler: { _ in
			self.confirmButtonTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		tokenNameLabel.text = sendConfirmationVM.formattedSendAmount
		sendAmountLabel.text = sendConfirmationVM.formattedSendAmountInDollar
		selectedWalletTitleLabel.text = sendConfirmationVM.selectedWalletTitle
		walletNameLabel.text = sendConfirmationVM.selectedWalletName
		recipientTitleLabel.text = sendConfirmationVM.recipientAddressTitle
		recipientAddressLabel.text = sendConfirmationVM.recipientAddress.shortenedString(
			characterCountFromStart: 6,
			characterCountFromEnd: 4
		)
		feeLabel.text = sendConfirmationVM.fee
		feeTitleView.title = sendConfirmationVM.feeTitle
		continueButton.title = sendConfirmationVM.confirmButtonTitle

		walletImageView.image = UIImage(named: sendConfirmationVM.selectedWalletImage)
		walletImageBackgroundView.backgroundColor = UIColor(named: sendConfirmationVM.selectedWalletImage)

		if sendConfirmationVM.isTokenVerified {
			tokenImageView.kf.indicatorType = .activity
			tokenImageView.kf.setImage(with: sendConfirmationVM.tokenImage)
		} else {
			tokenImageView.image = UIImage(named: sendConfirmationVM.customAssetImage)
		}

		tokenNameLabel.font = .PinoStyle.semiboldTitle2
		sendAmountLabel.font = .PinoStyle.mediumBody
		selectedWalletTitleLabel.font = .PinoStyle.mediumBody
		walletNameLabel.font = .PinoStyle.mediumBody
		recipientTitleLabel.font = .PinoStyle.mediumBody
		recipientAddressLabel.font = .PinoStyle.mediumBody
		feeLabel.font = .PinoStyle.mediumBody

		tokenNameLabel.tintColor = .Pino.label
		sendAmountLabel.textColor = .Pino.secondaryLabel
		selectedWalletTitleLabel.textColor = .Pino.secondaryLabel
		walletNameLabel.tintColor = .Pino.label
		recipientTitleLabel.textColor = .Pino.secondaryLabel
		recipientAddressLabel.textColor = .Pino.label
		feeLabel.textColor = .Pino.label

		backgroundColor = .Pino.background

		feeLabel.textAlignment = .right
		recipientAddressLabel.textAlignment = .right

		tokenStackView.axis = .vertical
		tokenAmountStackView.axis = .vertical
		cardsStackView.axis = .vertical
		sendInfoStackView.axis = .vertical

		tokenStackView.alignment = .center
		tokenAmountStackView.alignment = .center

		cardsStackView.spacing = 16
		tokenStackView.spacing = 16
		tokenAmountStackView.spacing = 4
		sendInfoStackView.spacing = 22
		walletInfoStackView.spacing = 4

		walletImageBackgroundView.layer.cornerRadius = 10
	}

	private func setupContstraint() {
		cardsStackView.pin(
			.horizontalEdges(padding: 16),
			.top(to: layoutMarginsGuide, padding: 24)
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
		feeTitleView.pin(
			.fixedWidth(48)
		)
		walletImageView.pin(
			.allEdges(padding: 3)
		)
	}
}
