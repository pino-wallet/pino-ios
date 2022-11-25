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
		setSteperView()
		setNavigationBackButton()
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

	private func setSteperView() {
		// show steper view in navigation bar
		let stepperView = PinoStepperView(stepsCount: 3, currentStep: 1)
		navigationItem.titleView = stepperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}

	private func shareSecretPhrase() {
		let userWords = secretPhraseVM.secretPhrase
		let shareText = "Secret Phrase: \(userWords.joined(separator: " "))"
		let shareActivity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
		present(shareActivity, animated: true) {}
	}

	private func goToVerifyPage() {
		let verifyViewController = VerifySecretPhraseViewController()
		verifyViewController.secretPhraseVM = secretPhraseVM
		navigationController?.pushViewController(verifyViewController, animated: true)
  }
	private func setNavigationBackButton() {
		let backImage = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem(
			image: backImage,
			style: .plain,
			target: self,
			action: #selector(backToPreviousPage)
		)
		backButton.tintColor = .Pino.label
		navigationItem.setLeftBarButton(backButton, animated: true)
	}

	@objc
	private func backToPreviousPage() {
		navigationController?.popViewController(animated: true)
	}

	private func setNavigationBackButton() {
		let backImage = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem(
			image: backImage,
			style: .plain,
			target: self,
			action: #selector(backToPreviousPage)
		)
		backButton.tintColor = .Pino.label
		navigationItem.setLeftBarButton(backButton, animated: true)
	}

	@objc
	private func backToPreviousPage() {
		navigationController?.popViewController(animated: true)
	}
}
