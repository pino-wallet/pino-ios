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
	}

	// MARK: Private Methods

	private func stupView() {
		let secretPhraseView = ShowSecretPhraseView(secretPhraseVM.secretPhrase) {
			self.shareSecretPhrase()
		}
		view = secretPhraseView
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let steperView = PinoSteperView(stepsCount: 3, currentStep: 1)
		navigationItem.titleView = steperView
		navigationController?.navigationBar.backgroundColor = .Pino.background
	}

	@objc
	private func shareSecretPhrase() {
		let userWords = secretPhraseVM.secretPhrase.map { $0.title }
		let shareText = "Secret Phrase: \(userWords.joined(separator: " "))"
		let shareActivity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
		present(shareActivity, animated: true) {}
	}
}
