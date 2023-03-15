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
			shareSecretPhare: {
				self.shareSecretPhrase()
			},
			savedSecretPhrase: {
				self.goToVerifyPage()
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

	private func shareSecretPhrase() {
		let userWords = secretPhraseVM.secretPhraseList
		let shareText = userWords.joined(separator: " ")
		let shareActivity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
		present(shareActivity, animated: true) {}
	}

	private func goToVerifyPage() {
		let verifyViewController = VerifySecretPhraseViewController()
		verifyViewController.secretPhraseVM = VerifySecretPhraseViewModel(secretPhraseVM.secretPhraseList)
		navigationController?.pushViewController(verifyViewController, animated: true)
	}
}
