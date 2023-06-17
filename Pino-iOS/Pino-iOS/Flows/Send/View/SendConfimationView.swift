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
		walletInfoStackView.addArrangedSubview(walletImageView)
		walletInfoStackView.addArrangedSubview(walletNameLabel)
		recipientStrackView.addArrangedSubview(recipientTitleLabel)
		recipientStrackView.addArrangedSubview(recipientAddressLabel)
		feeStrackView.addArrangedSubview(feeTitleView)
		feeStrackView.addArrangedSubview(feeLabel)

		continueButton.addAction(UIAction(handler: { _ in
			self.confirmButtonTapped()
		}), for: .touchUpInside)
	}

	private func setupStyle() {
		tokenNameLabel.text = "0"
		sendAmountLabel.text = "0"
		selectedWalletTitleLabel.text = "0"
		walletNameLabel.text = "0"
		recipientTitleLabel.text = "0"
		recipientAddressLabel.text = "0"
		feeLabel.text = "0"
		feeTitleView.title = "0"
		continueButton.title = "0"

		walletImageView.image = UIImage(named: "")
		tokenImageView.image = UIImage(named: "")

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
		walletImageView.pin(
			.fixedWidth(20),
			.fixedHeight(20)
		)
		feeTitleView.pin(
			.fixedWidth(45)
		)
	}
}
