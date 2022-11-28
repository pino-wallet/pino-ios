//
//  VerifySecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class VerifySecretPhraseViewController: UIViewController {
	// MARK: Public Properties

	public var secretPhraseVM: SecretPhraseViewModel!

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: 3, curreuntStep: 2)
		setupNavigationBackButton()
	}

	// MARK: Private Methods

	private func createWallet(_ sortedPhrase: [String]) {
		// Wallet should be created here
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 3
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}

extension VerifySecretPhraseViewController {
	// MARK: Private UI Methods

	private func stupView() {
		let verifySecretPhraseView = VerifySecretPhraseView(secretPhraseVM.secretPhrase) { sortedPhrase in
			self.createWallet(sortedPhrase)
		}
		view = verifySecretPhraseView
	}
}
