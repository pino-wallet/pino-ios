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

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
	}

	// MARK: - Private Methods

	private func setupView() {
		sendStatusView = SendStatusView(toggleIsModalInPresentation: { isModelInPresentation in
			print("\(isModelInPresentation) ehhhhh")
			self.isModalInPresentation = isModelInPresentation
		})
		sendStatusView.onDissmiss = {
			self.dismiss(animated: true)
		}
		view = sendStatusView
	}
}
