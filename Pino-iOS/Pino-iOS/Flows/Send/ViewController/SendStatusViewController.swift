//
//  SendStatusViewController.swift
//  Pino-iOS
//
//  Created by Amir hossein kazemi seresht on 6/18/23.
//

import UIKit

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

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
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
