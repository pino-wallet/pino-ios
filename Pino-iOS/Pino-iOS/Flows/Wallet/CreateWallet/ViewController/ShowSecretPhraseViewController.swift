//
//  ShowSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/13/22.
//

import UIKit

class ShowSecretPhraseViewController: UIViewController {
	// MARK: Public Properties

	public var isNewWallet = false

	// MARK: Private Properties

	private var secretPhraseVM = ShowSecretPhraseViewModel()

	// MARK: View Overrides

	override func viewDidLoad() {
		secretPhraseVM.generateMnemonics()
		setupView()
		super.viewDidLoad()
	}

	override func loadView() {
		if isNewWallet {
			setupPrimaryColorNavigationBar()
			setNavigationTitle(secretPhraseVM.pageTitle)
		} else {
			setSteperView(stepsCount: 3, curreuntStep: 1)
		}
	}
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotifications()
    }

	// MARK: - Initializers

	deinit {
        removeNotifications()
	}

	// MARK: Private Methods

	private func setupView() {
		let secretPhraseView = ShowSecretPhraseView(
			secretPhraseVM: secretPhraseVM,
			shareSecretPhare: {
				self.shareSecretPhrase()
			},
			savedSecretPhrase: {
				self.goToVerifyPage()
			}
		)
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
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
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
//		let verifyViewController = VerifySecretPhraseViewController()
//		verifyViewController.secretPhraseVM = VerifySecretPhraseViewModel(secretPhraseVM.secretPhraseList)
//		navigationController?.pushViewController(verifyViewController, animated: true)

		/// Temporarily removing verify step and moving to create pass section
		let createPasscodeViewController = CreatePasscodeViewController(
			selectedAccounts: nil, mnemonics: secretPhraseVM.secretPhraseList
				.joined(separator: " ")
		)
		createPasscodeViewController.pageSteps = 3
		createPasscodeViewController.currentStep = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
