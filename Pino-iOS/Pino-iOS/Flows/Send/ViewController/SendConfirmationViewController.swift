//
//  SendConfirmationViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 6/17/23.
//

import UIKit

class SendConfirmationViewController: UIViewController {
	// MARK: Private Properties

	// MARK: Initializers

	//    init(selectedAsset: AssetViewModel, enteredAmount: String, walletInfo: AccountInfoViewModel, recipientAddress: String) {
	//        super.init(nibName: nil, bundle: nil)
	//    }
//
	//    required init?(coder: NSCoder) {
	//        fatalError("init(coder:) has not been implemented")
	//    }

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = SendConfirmationView(confirmButtonTapped: {})
	}

	private func setupNavigationBar() {
		// Setup appreance for navigation bar
		setupPrimaryColorNavigationBar()
		// Setup title view
		setNavigationTitle("Confirm transfer")
	}
}
