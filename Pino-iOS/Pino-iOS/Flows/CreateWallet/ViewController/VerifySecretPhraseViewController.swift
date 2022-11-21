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
		setNavigationBackButton()
	}

	// MARK: Private Methods

	private func createWallet(_ sortedPhrase: [String]) {
		// Wallet should be created here
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}

	@objc
	private func backToPreviousPage() {
		navigationController?.popViewController(animated: true)
	}
}

extension VerifySecretPhraseViewController {
	// MARK: Private UI Methods

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
}
