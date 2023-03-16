//
//  ReceiveAssetView.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 2/23/23.
//

import UIKit
import WebKit

class ReceiveAssetView: UIView, WKUIDelegate {
	// MARK: Typealias

	typealias presentShareActivityClosureType = (_ sharedText: String) -> Void

	// MARK: - Public Properties

	public var homeVM: HomepageViewModel
	public var receiveVM: ReceiveViewModel

	// MARK: - Closure

	public var presentShareActivityClosure: presentShareActivityClosureType

	// MARK: - Private Properties

	private let addressQRCodeImageCardView = UIView()
	private let qrCodeBordersCard = UIView()
	private var addressQRCodeWebView = WKWebView()
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
		presentShareActivityClosure: @escaping presentShareActivityClosureType,
		receiveVM: ReceiveViewModel
	) {
		self.homeVM = homeVM
		self.receiveVM = receiveVM
		self.presentShareActivityClosure = presentShareActivityClosure
		super.init(frame: .zero)
		setupView()
		setupQRCode()
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

		addressQRCodeImageCardView.addSubview(addressQRCodeWebView)
		addressQRCodeImageCardView.addSubview(qrCodeBordersCard)
		addressQRCodeImageCardView.layer.borderWidth = 1
		addressQRCodeImageCardView.layer.borderColor = UIColor.Pino.background.cgColor
		addressQRCodeImageCardView.layer.cornerRadius = 12

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
			self?.presentShareActivityClosure((self?.homeVM.walletInfo.address)!)
		}

		actionButtonsStackView.axis = .horizontal
		actionButtonsStackView.spacing = 60
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
		addressQRCodeWebView.pin(.allEdges(to: addressQRCodeImageCardView, padding: 6))
		qrCodeBordersCard.pin(.allEdges(to: addressQRCodeImageCardView, padding: 15))
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
		qrCodeBordersCard.isHidden = false
		let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "WebViewFiles")!
		addressQRCodeWebView.loadFileURL(url, allowingReadAccessTo: url)
		let request = URLRequest(url: url)
		addressQRCodeWebView.load(request)
		addressQRCodeWebView.uiDelegate = self
		addressQRCodeWebView.navigationDelegate = self
	}
}

extension ReceiveAssetView: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		let qrCode = homeVM.walletInfo.address
		addressQRCodeWebView.evaluateJavaScript(
			"generateAndShowQRCode('\(qrCode)')",
			completionHandler: { result, error in
				guard error == nil else {
					fatalError("cant generate qrCode")
				}
			}
		)
	}
}
