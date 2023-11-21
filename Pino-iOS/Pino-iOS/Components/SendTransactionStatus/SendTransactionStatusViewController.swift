//
//  SendTransactionStatusViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 11/20/23.
//

import UIKit
import Web3_Utility

class SendTransactionStatusViewController: UIViewController {
	// MARK: - Private Properties

	private var sendStatusView: SendTransactionStatusView!
	private var sendStatusVM: SendTransactionStatusViewModel

	// MARK: - Initializers

	init(sendStatusVM: SendTransactionStatusViewModel) {
		self.sendStatusVM = sendStatusVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if isBeingPresented || isMovingToParent {
			clearNavbar()
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		sendStatusVM.destroyRequestTimer()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		sendStatusView = SendTransactionStatusView(toggleIsModalInPresentation: { isModelInPresentation in
			self.isModalInPresentation = isModelInPresentation
		}, sendStatusVM: sendStatusVM)
		sendStatusView.onDissmiss = {
			self.dismiss(animated: true)
		}
		view = sendStatusView
	}
}
