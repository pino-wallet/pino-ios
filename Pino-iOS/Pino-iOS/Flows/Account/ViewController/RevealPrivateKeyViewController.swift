//
//  RevealPrivateKeyViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

import UIKit

class RevealPrivateKeyViewController: UIViewController {
	// MARK: Private Properties

	private let revealPrivateKeyVM = RevealPrivateKeyViewModel()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
		setupNotifications()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = RevealPrivateKeyView(
			revealPrivateKeyVM: revealPrivateKeyVM,
			copyPrivateKeyTapped: {
				self.copyPrivateKey()
			},
			doneButtonTapped: {
				self.dismissPage()
			}
		)
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Your private key")
	}

	private func setupNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(screenshotTaken),
			name: UIApplication.userDidTakeScreenshotNotification,
			object: nil
		)
	}

	@objc
	private func screenshotTaken() {
		let screenshotAlertController = AlertHelper.alertController(
			title: revealPrivateKeyVM.screenshotAlertTitle,
			message: revealPrivateKeyVM.screenshotAlertMessage,
			actions: [.gotIt()]
		)
		present(screenshotAlertController, animated: true)
	}

	private func copyPrivateKey() {}

	private func dismissPage() {
		navigationController?.popViewController(animated: true)
	}
}
