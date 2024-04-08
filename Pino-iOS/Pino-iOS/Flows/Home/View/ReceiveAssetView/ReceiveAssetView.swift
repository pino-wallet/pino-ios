//
//  ReceiveAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit

class ReceiveAssetView: UIView {
	// MARK: - Public Properties

	public var receiveVM: ReceiveViewModel
	public var addressQrCodeImage: UIImage? {
		didSet {
			setupQRCode()
		}
	}

	// MARK: - Private Properties

	private let addressQRCodeImageCardView = UIView()
	private let qrCodeBordersCard = UIView()
	private let accountInfoStackView = UIStackView()
	private let accountOwnerName = PinoLabel(style: .title, text: "")
	private let addressLabel = PinoLabel(style: .description, text: "")
	private let addressLabelContainer = UIView()
	private let copyAddressButton = ReceiveActionButton()
	private let addressQrCodeImageView = UIImageView()
	private let paymentMethodOption = PaymentMethodOptionView()

	// MARK: Initializers

	init(
		receiveVM: ReceiveViewModel
	) {
		self.receiveVM = receiveVM
		super.init(frame: .zero)
		setupView()
		setupContstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		backgroundColor = .Pino.secondaryBackground

		qrCodeBordersCard.layer.borderWidth = 1
		qrCodeBordersCard.layer.borderColor = UIColor.Pino.background.cgColor
		qrCodeBordersCard.layer.cornerRadius = 4
		qrCodeBordersCard.isHidden = true

		addressQRCodeImageCardView.addSubview(addressQrCodeImageView)
		addressQRCodeImageCardView.addSubview(qrCodeBordersCard)
		addressQRCodeImageCardView.layer.borderWidth = 1
		addressQRCodeImageCardView.layer.borderColor = UIColor.Pino.background.cgColor
		addressQRCodeImageCardView.layer.cornerRadius = 12

		addressQrCodeImageView.backgroundColor = .Pino.white

		accountOwnerName.font = UIFont.PinoStyle.semiboldTitle2
		accountOwnerName.numberOfLines = 0
		accountOwnerName.text = receiveVM.accountName

		addressLabelContainer.layer.borderColor = UIColor.Pino.background.cgColor
		addressLabelContainer.layer.borderWidth = 1
		addressLabelContainer.layer.cornerRadius = 20
		addressLabelContainer.addSubview(addressLabel)

		addressLabel.numberOfLines = 1
		addressLabel.text = receiveVM.accountAddress
		addressLabel.lineBreakMode = .byTruncatingMiddle
		addressLabel.textAlignment = .center
		addressLabel.textColor = .Pino.primary

		accountInfoStackView.axis = .horizontal
		accountInfoStackView.spacing = 12
		accountInfoStackView.addArrangedSubview(addressLabelContainer)
		accountInfoStackView.addArrangedSubview(copyAddressButton)

		copyAddressButton.iconName = receiveVM.copyAddressButtonIconName
		copyAddressButton.titleText = receiveVM.copyAddressButtonText
		copyAddressButton.onTap = { [self] in
			UIPasteboard.general.string = receiveVM.accountAddress
			Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
		}

		addSubview(accountOwnerName)
		accountOwnerName.textAlignment = .center
		addSubview(addressQRCodeImageCardView)
		addSubview(accountInfoStackView)
		paymentMethodOption
			.paymentMethodOptionVM = PaymentMethodOptionViewModel(paymentMethodOption: receiveVM.paymentMethodOptions[0])
		addSubview(paymentMethodOption)
	}

	private func setupContstraints() {
		accountOwnerName.pin(.top(to: layoutMarginsGuide, padding: 32), .centerX())
		addressQRCodeImageCardView.pin(
			.relative(.top, 24, to: accountOwnerName, .bottom),
			.centerX(to: layoutMarginsGuide),
			.fixedWidth(300),
			.fixedHeight(300)
		)
		addressQrCodeImageView.pin(.allEdges(to: addressQRCodeImageCardView, padding: 10))
		qrCodeBordersCard.pin(.allEdges(to: addressQRCodeImageCardView, padding: 18))
		accountInfoStackView.pin(
			.relative(.top, 16, to: addressQRCodeImageCardView, .bottom),
			.centerX(),
			.fixedHeight(40),
			.fixedWidth(300)
		)
		addressLabel.pin(.centerY(), .horizontalEdges(to: superview, padding: 22))
		paymentMethodOption.pin(.horizontalEdges(padding: 16), .relative(.top, 174, to: accountInfoStackView, .bottom))
	}

	private func setupQRCode() {
		qrCodeBordersCard.isHidden = false
		addressQrCodeImageView.image = addressQrCodeImage
	}
}
