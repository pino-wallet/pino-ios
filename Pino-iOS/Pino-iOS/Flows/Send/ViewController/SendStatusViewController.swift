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
	private var fallback: () -> Void

	// MARK: - Initializers

	init(confirmationVM: SendConfirmationViewModel, completion: @escaping () -> Void) {
		self.confirmationVM = confirmationVM
		self.fallback = completion
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()

		do {
			try confirmationVM.sendToken().done { [self] trxHash in
				sendStatusView.pageStatus = .success
			}.catch { [self] error in
				sendStatusView.pageStatus = .failed
			}
		} catch {
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
			self.fallback()
		}
		view = sendStatusView
	}
}
