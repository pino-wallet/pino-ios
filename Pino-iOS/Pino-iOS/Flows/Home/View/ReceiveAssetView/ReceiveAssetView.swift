//
//  ReceiveAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit
import WebKit

class ReceiveAssetView: UIView, WKUIDelegate {
	// MARK: - Public Properties

	public var homeVM: HomepageViewModel
	public var receiveVM: ReceiveViewModel
	public var addressQrCodeImage: UIImage? {
		didSet {
			setupQRCode()
		}
	}

	// MARK: - Private Properties

	private let addressQRCodeImageCardView = UIView()
	private let qrCodeBordersCard = UIView()
	private let walletInfoStackView = UIStackView()
	private let walletOwnerName = PinoLabel(style: .title, text: "")
	private let addressLabel = PinoLabel(style: .description, text: "")
	private let addressLabelContainer = UIView()
	private let copyAddressButton = ReceiveActionButton()
	private let copiedToastView = PinoToastView(message: nil, style: .primary)
	private let qrCodeLoadingIndicator = PinoLoading(size: 32)
	private let addressQrCodeImageView = UIImageView()
	private let paymentMethodOption = PaymentMethodOptionView()

	// MARK: Initializers

	init(
		homeVM: HomepageViewModel,
		receiveVM: ReceiveViewModel
	) {
		self.homeVM = homeVM
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

		addressQRCodeImageCardView.addSubview(qrCodeLoadingIndicator)

		addressQrCodeImageView.backgroundColor = .Pino.white

		walletOwnerName.font = UIFont.PinoStyle.semiboldTitle2
		walletOwnerName.numberOfLines = 0
		walletOwnerName.text = "\(homeVM.walletInfo.name)’s \(receiveVM.walletOwnerNameDescriptionText)"

		addressLabelContainer.layer.borderColor = UIColor.Pino.background.cgColor
		addressLabelContainer.layer.borderWidth = 1
		addressLabelContainer.layer.cornerRadius = 20
		addressLabelContainer.addSubview(addressLabel)

		addressLabel.numberOfLines = 1
		addressLabel.text = homeVM.walletInfo.address
		addressLabel.lineBreakMode = .byTruncatingMiddle
		addressLabel.textAlignment = .center
		addressLabel.textColor = .Pino.primary

		walletInfoStackView.axis = .horizontal
		walletInfoStackView.spacing = 12
		walletInfoStackView.addArrangedSubview(addressLabelContainer)
		walletInfoStackView.addArrangedSubview(copyAddressButton)

		copyAddressButton.iconName = receiveVM.copyAddressButtonIconName
		copyAddressButton.titleText = receiveVM.copyAddressButtonText
		copyAddressButton.onTap = { [weak self] in
			UIPasteboard.general.string = self?.homeVM.walletInfo.address
			self?.copiedToastView.message = self?.receiveVM.copiedToastViewText
			self?.copiedToastView.showToast()
		}

		addSubview(walletOwnerName)
		walletOwnerName.textAlignment = .center
		addSubview(addressQRCodeImageCardView)
		addSubview(walletInfoStackView)
		paymentMethodOption
			.paymentMethodOptionVM = PaymentMethodOptionViewModel(paymentMethodOption: receiveVM.paymentMethodOptions[0])
		addSubview(paymentMethodOption)
	}

	private func setupContstraints() {
		walletOwnerName.pin(.top(to: layoutMarginsGuide, padding: 32), .centerX())
		addressQRCodeImageCardView.pin(
			.relative(.top, 24, to: walletOwnerName, .bottom),
			.centerX(to: layoutMarginsGuide),
			.fixedWidth(300),
			.fixedHeight(300)
		)
		qrCodeLoadingIndicator.pin(.centerY(to: superview), .centerX(to: superview))
		addressQrCodeImageView.pin(.allEdges(to: addressQRCodeImageCardView, padding: 9))
		qrCodeBordersCard.pin(.allEdges(to: addressQRCodeImageCardView, padding: 18))
		walletInfoStackView.pin(
			.relative(.top, 16, to: addressQRCodeImageCardView, .bottom),
			.centerX(),
			.fixedHeight(40),
			.fixedWidth(300)
		)
		addressLabel.pin(.centerY(), .horizontalEdges(to: superview, padding: 22))
		paymentMethodOption.pin(.horizontalEdges(padding: 16), .relative(.top, 174, to: walletInfoStackView, .bottom))
	}

	private func setupQRCode() {
		qrCodeBordersCard.isHidden = false
		qrCodeLoadingIndicator.isHidden = true
		addressQrCodeImageView.image = addressQrCodeImage
	}
}
