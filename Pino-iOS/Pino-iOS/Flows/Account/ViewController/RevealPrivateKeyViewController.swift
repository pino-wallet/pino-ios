//
//  RevealPrivateKeyViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/13/23.
//

import UIKit

class RevealPrivateKeyViewController: UIViewController {
	// MARK: Private Properties

	private var revealPrivateKeyView: RevealPrivateKeyView!
	private let revealPrivateKeyVM = RevealPrivateKeyViewModel()
	private let copyPrivateKeyToastView = PinoToastView(message: nil, style: .secondary, padding: 80)

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
		revealPrivateKeyView = RevealPrivateKeyView(
			revealPrivateKeyVM: revealPrivateKeyVM,
			copyPrivateKeyTapped: {
				self.copyPrivateKey()
			},
			doneButtonTapped: {
				self.dismissPage()
			},
			revealTapped: {
				self.showFaceID()
			}
		)
		view = revealPrivateKeyView
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

	private func copyPrivateKey() {
		let pasteboard = UIPasteboard.general
		pasteboard.string = revealPrivateKeyVM.privateKey
		copyPrivateKeyToastView.message = "Private key has been copied"
		copyPrivateKeyToastView.showToast()
	}

	private func dismissPage() {
		navigationController?.popViewController(animated: true)
	}

	private func showFaceID() {
		var faceIDLock = BiometricAuthentication()
		faceIDLock.evaluate {
			self.revealPrivateKeyView.showPrivateKey()
		}
	}
}
