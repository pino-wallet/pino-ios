//
//  EnterAddressViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/15/23.
//

import UIKit

class EnterSendAddressViewController: UIViewController {
	// MARK: - Private Properties

	private var enterSendAddressView: EnterSendAddressView!
	private var enterSendAddressVM: EnterSendAddressViewModel

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Initializers

	init(enterAddressVM: EnterSendAddressViewModel) {
		self.enterSendAddressVM = enterAddressVM

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
		enterSendAddressVM.didValidateSendAddress = { [weak self] validationStatus in
			self?.enterSendAddressView.validationStatus = validationStatus
		}
		enterSendAddressView.tapNextButton = {
			self.openConfiramtionPage()
		}
		enterSendAddressView.scanAddressQRCode = {
			let qrScanner = QRScannerViewController(foundAddress: { address in
				self.enterSendAddressView.addressTextField.text = address
				self.enterSendAddressVM.validateSendAddress(address: address)

			})
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
		guard let address = enterSendAddressView.addressTextField.getText(),
		      enterSendAddressView.validationStatus == .success else { return }

		let confirmationVM = SendConfirmationViewModel(
			selectedToken: enterSendAddressVM.sendAmountVM.selectedToken,
			selectedWallet: enterSendAddressVM.selectedWallet,
			recipientAddress: address,
			sendAmount: enterSendAddressVM.sendAmountVM.tokenAmount,
			sendAmountInDollar: enterSendAddressVM.sendAmountVM.dollarAmount
		)
		let confirmationVC = SendConfirmationViewController(sendConfirmationVM: confirmationVM)
		navigationController?.pushViewController(confirmationVC, animated: true)
	}
}
