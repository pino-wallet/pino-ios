//
//  VerifySecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/15/22.
//

import UIKit

class VerifySecretPhraseViewController: UIViewController {
	// MARK: Private Properties

	private var verifySecretPhraseView: VerifySecretPhraseView?

	// MARK: Public Properties

	public var secretPhraseVM: SecretPhraseViewModel!

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
		verifySecretPhraseView = VerifySecretPhraseView(secretPhraseVM.secretPhrase) { sortedPhrase in
			self.createWallet(sortedPhrase)
		}
		view = verifySecretPhraseView
	}

	private func setSteperView() {
		// show steper view in navigation bar
		let steperView = PinoStepperView(stepsCount: 3, currentStep: 2)
		navigationItem.titleView = steperView
		navigationController?.navigationBar.backgroundColor = .Pino.secondaryBackground
	}

	private func createWallet(_ sortedPhrase: [SeedPhrase]) {
		#warning("This code should be uncommented before push")
//		if secretPhraseVM.isVerified(selectedPhrase: sortedPhrase) {
		// Wallet should be created here
		// Go to create passcode page
		let createPassVC = CreatePasscodeViewController()
		navigationController?.pushViewController(createPassVC, animated: true)
//		}
	}
}
