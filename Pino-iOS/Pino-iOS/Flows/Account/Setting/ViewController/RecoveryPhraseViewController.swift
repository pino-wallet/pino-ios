//
//  RecoveryPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/15/23.
//

import UIKit

class RecoveryPhraseViewController: UIViewController {
	// MARK: - Private Properties

	private let secretPhraseVM = RecoveryPhraseViewModel()
	private var recoverPhraseView: RecoveryPhraseView!
	private lazy var authManager: AuthenticationLockManager = {
		.init(parentController: self)
	}()

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
		recoverPhraseView = RecoveryPhraseView(
			secretPhraseVM: secretPhraseVM,
			copySecretPhraseTapped: {
				self.copySecretPhrase()
			},
			revealTapped: {
				self.showFaceID()
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
		Toast.default(title: GlobalToastTitles.copy.message, style: .copy).show(haptic: .success)
	}

	private func showFaceID() {
		authManager.unlockApp {
			self.recoverPhraseView.showSeedPhrase()
		}
	}
}
