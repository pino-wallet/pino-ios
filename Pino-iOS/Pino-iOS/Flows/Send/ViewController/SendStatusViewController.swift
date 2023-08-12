//
//  SendStatusViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/18/23.
//

import UIKit
import Web3_Utility

class SendStatusViewController: UIViewController {
	// MARK: - Private Properties
    
	private var sendStatusView: SendStatusView!
	private var confirmationVM: SendConfirmationViewModel

	// MARK: - Initializers

	init(confirmationVM: SendConfirmationViewModel) {
		self.confirmationVM = confirmationVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		clearNavbar()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()

		confirmationVM.sendToken().done { [self] trxHash in
			sendStatusView.pageStatus = .success
            confirmationVM.addPendingTransferActivity(trxHash: trxHash)
		}.catch { [self] error in
			sendStatusView.pageStatus = .failed
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		sendStatusView = SendStatusView(toggleIsModalInPresentation: { isModelInPresentation in
			self.isModalInPresentation = isModelInPresentation
		})
		sendStatusView.onDissmiss = {
			self.dismiss(animated: true)
		}
		view = sendStatusView
	}
}
