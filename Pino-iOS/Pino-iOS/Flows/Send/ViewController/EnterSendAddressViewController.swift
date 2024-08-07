//
//  EnterAddressViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//

import UIKit

class EnterSendAddressViewController: UIViewController {
	// MARK: - Private Properties

	private let hapticManager = HapticManager()
	private var enterSendAddressView: EnterSendAddressView!
	private var enterSendAddressVM: EnterSendAddressViewModel
	private var onSendConfirm: (SendTransactionStatus) -> Void

	// MARK: - View Overrides

	override func viewDidAppear(_ animated: Bool) {
		if isMovingToParent {
			enterSendAddressView.showSuggestedAddresses()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			hapticManager.run(type: .selectionChanged)
		}
	}

	// MARK: - Initializers

	init(enterAddressVM: EnterSendAddressViewModel, onSendConfirm: @escaping (SendTransactionStatus) -> Void) {
		self.enterSendAddressVM = enterAddressVM
		self.onSendConfirm = onSendConfirm
		super.init(nibName: nil, bundle: nil)
		setupView()
		setupNavigationBar()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupView() {
		enterSendAddressView = EnterSendAddressView(enterSendAddressVM: enterSendAddressVM)
		enterSendAddressView.tapNextButton = {
			self.hapticManager.run(type: .lightImpact)
			self.openConfiramtionPage()
		}
		enterSendAddressView.scanAddressQRCode = {
			self.hapticManager.run(type: .selectionChanged)
			let qrScanner = QRScannerViewController(
				scannerTitle: self.enterSendAddressVM.sendAddressQrCodeScannerTitle,
				foundAddress: { address in
					self.enterSendAddressView.addressTextField.text = address
					self.enterSendAddressVM.validateSendAddress(address: address)
				}
			)
			self.present(qrScanner, animated: true)
		}

		view = enterSendAddressView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle(
			"\(enterSendAddressVM.pageTitlePreFix) \(enterSendAddressVM.sendAmountVM.selectedToken.symbol)"
		)
	}

	private func openConfiramtionPage() {
		guard let address = enterSendAddressVM.recipientAddress, enterSendAddressVM.validationStatus == .success else {
			return
		}
		let confirmationVM = SendConfirmationViewModel(
			selectedToken: enterSendAddressVM.sendAmountVM.selectedToken,
			selectedWallet: enterSendAddressVM.selectedWallet,
			recipientAddress: address,
			sendAmount: enterSendAddressVM.sendAmountVM.tokenAmount!,
			sendAmountInDollar: enterSendAddressVM.sendAmountVM.dollarAmount
		)
		let confirmationVC = SendConfirmationViewController(
			sendConfirmationVM: confirmationVM,
			onSendConfirm: { pageStatus in
				self.onSendConfirm(pageStatus)
			}
		)
		navigationController?.pushViewController(confirmationVC, animated: true)
	}
}
