//
//  ReceiveAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit

class ReceiveAssetView: UIView {
	// MARK: Typealias

	typealias presentShareActivityViewControllerClosureType = (_ sharedText: String) -> Void

	// MARK: - Public Properties

	public var homeVM: HomepageViewModel
	public var receiveVM: ReceiveViewModel
	public var generatedQRCodeImage: UIImage! {
		didSet {
			setupQRCode()
		}
	}

	// MARK: - Closure

	public var presentShareActivityViewControllerClosure: presentShareActivityViewControllerClosureType

	// MARK: - Private Properties

	private let addressQRCodeImageCardView = UIView()
	private let qrCodeBordersCard = UIView()
	private var addressQRCodeImageView = UIImageView()
	private let qrCodeLoadingIndicator = PinoLoading(size: 22)
	private let walletInfoStackView = UIStackView()
	private let walletOwnerName = PinoLabel(style: .title, text: "")
	private let addressLabel = PinoLabel(style: .description, text: "")
	private let actionButtonsStackView = UIStackView()
	private let copyAddressButton = ReceiveViewActionButton()
	private let shareAddressButton = ReceiveViewActionButton()
	private let copiedToastView = PinoToastView(message: nil, style: .primary)

	// MARK: Initializers

	init(
		homeVM: HomepageViewModel,
		presentShareActivityViewControllerClosure: @escaping presentShareActivityViewControllerClosureType,
		receiveVM: ReceiveViewModel
	) {
		self.homeVM = homeVM
		self.receiveVM = receiveVM
		self.presentShareActivityViewControllerClosure = presentShareActivityViewControllerClosure
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
		qrCodeBordersCard.isHidden = true

		addressQRCodeImageCardView.addSubview(addressQRCodeImageView)
		addressQRCodeImageCardView.addSubview(qrCodeBordersCard)
		addressQRCodeImageCardView.layer.borderWidth = 1
		addressQRCodeImageCardView.layer.borderColor = UIColor.Pino.background.cgColor
		addressQRCodeImageCardView.layer.cornerRadius = 12

		addressQRCodeImageView.addSubview(qrCodeLoadingIndicator)

		walletOwnerName.font = UIFont.PinoStyle.mediumTitle3
		walletOwnerName.numberOfLines = 0
		walletOwnerName.text = "\(homeVM.walletInfo.name) \(receiveVM.walletOwnerNameDescriptionText)"

		addressLabel.text = homeVM.walletInfo.address

		walletInfoStackView.axis = .vertical
		walletInfoStackView.alignment = .center
		walletInfoStackView.spacing = 12
		walletInfoStackView.addArrangedSubview(walletOwnerName)
		walletOwnerName.textAlignment = .center
		walletInfoStackView.addArrangedSubview(addressLabel)
		addressLabel.textAlignment = .center

		copyAddressButton.iconName = receiveVM.copyAddressButtonIconName
		copyAddressButton.titleText = receiveVM.copyAddressButtonText
		copyAddressButton.onTap = { [weak self] in
			UIPasteboard.general.string = self?.homeVM.walletInfo.address
			self?.copiedToastView.message = self?.receiveVM.copiedToastViewText
			self?.copiedToastView.showToast()
		}

		shareAddressButton.iconName = receiveVM.shareAddressButtonIconName
		shareAddressButton.titleText = receiveVM.shareAddressButtonText
		shareAddressButton.onTap = { [weak self] in
			self?.presentShareActivityViewControllerClosure((self?.homeVM.walletInfo.address)!)
		}

		actionButtonsStackView.axis = .horizontal
		actionButtonsStackView.spacing = 40
		actionButtonsStackView.addArrangedSubview(copyAddressButton)
		actionButtonsStackView.addArrangedSubview(shareAddressButton)

		addSubview(addressQRCodeImageCardView)
		addSubview(walletInfoStackView)
		addSubview(actionButtonsStackView)
	}

	private func setupContstraints() {
		addressQRCodeImageCardView.pin(
			.top(to: layoutMarginsGuide, padding: 32),
			.centerX(to: layoutMarginsGuide),
			.fixedWidth(270),
			.fixedHeight(270)
		)
		addressQRCodeImageView.pin(.allEdges(to: addressQRCodeImageCardView, padding: 6))
		qrCodeBordersCard.pin(.allEdges(to: addressQRCodeImageCardView, padding: 15))
		qrCodeLoadingIndicator.pin(.centerY(to: superview), .centerX(to: superview))
		walletInfoStackView.pin(
			.relative(.top, 32, to: addressQRCodeImageCardView, .bottom),
			.horizontalEdges(to: layoutMarginsGuide, padding: 24)
		)
		actionButtonsStackView.pin(
			.centerX(to: layoutMarginsGuide),
			.relative(.top, 38, to: walletInfoStackView, .bottom)
		)
	}

	private func setupQRCode() {
		qrCodeLoadingIndicator.isHidden = true
		qrCodeBordersCard.isHidden = false
		addressQRCodeImageView.image = generatedQRCodeImage
	}
}
