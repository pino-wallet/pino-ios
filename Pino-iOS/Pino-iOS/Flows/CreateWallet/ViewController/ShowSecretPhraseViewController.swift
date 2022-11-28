//
//  ShowSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseViewController: UIViewController {
	// MARK: Private Properties

	private let secretPhraseVM = SecretPhraseViewModel()

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: 3, curreuntStep: 1)
		setupNavigationBackButton()
		setupNotifications()
	}

	// MARK: Private Methods

	private func stupView() {
		let secretPhraseView = ShowSecretPhraseView(secretPhraseVM.secretPhrase, shareSecretPhare: {
			self.shareSecretPhrase()
		}, savedSecretPhrase: {
			self.goToVerifyPage()
		})
		view = secretPhraseView
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
		AlertHelper.showAlert(
			title: "Warning",
			message: "It isn't safe to take a screenshot of a secret phrase!",
			over: self
		)
	}

	private func shareSecretPhrase() {
		let userWords = secretPhraseVM.secretPhrase
		let shareText = userWords.joined(separator: " ")
		let shareActivity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
		present(shareActivity, animated: true) {}
	}

	private func goToVerifyPage() {
		let verifyViewController = VerifySecretPhraseViewController()
		verifyViewController.secretPhraseVM = secretPhraseVM
		navigationController?.pushViewController(verifyViewController, animated: true)
	}
}
