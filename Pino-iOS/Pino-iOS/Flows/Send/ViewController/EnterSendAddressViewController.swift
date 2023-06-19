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
			#warning("go to confirm page")
		}

		view = enterSendAddressView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		setNavigationTitle("\(enterSendAddressVM.pageTitlePreFix) \(enterSendAddressVM.selectedAsset.symbol)")
	}
}
