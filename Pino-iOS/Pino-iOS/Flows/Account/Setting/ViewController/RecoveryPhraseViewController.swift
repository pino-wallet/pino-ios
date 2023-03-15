//
//  RecoveryPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import UIKit

class RecoveryPhraseViewController: UIViewController {
	// MARK: - Private Properties

	private let secretPhraseVM = ShowSecretPhraseViewModel()
	private let copyToastView = PinoToastView(message: nil, style: .secondary, padding: 23)

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
		let recoverPhraseView = RecoveryPhraseView(
			secretPhraseVM: secretPhraseVM,
			copySecretPhraseTapped: {
				self.copySecretPhrase()
			}
		)
		view = recoverPhraseView
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Recovery phrase")
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
			title: secretPhraseVM.screenshotAlertTitle,
			message: secretPhraseVM.screenshotAlertMessage,
			actions: [.gotIt()]
		)
		present(screenshotAlertController, animated: true)
	}

	private func copySecretPhrase() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = secretPhraseVM.secretPhraseList.joined(separator: " ")
		copyToastView.message = "Secret phrase has been copied"
		copyToastView.showToast()
	}
}
