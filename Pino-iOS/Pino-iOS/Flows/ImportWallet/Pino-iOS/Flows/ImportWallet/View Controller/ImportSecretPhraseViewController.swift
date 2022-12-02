//
//  ImportWalletViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: - Properties

	public var importsecretPhradseView: ImportSecretPhraseView?
	public var validationSecretPhraseViewVM: ValidateSecretPhraseVM!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: 2, curreuntStep: 1)
		setupNavigationBackButton()
	}

	// MARK: - Private Methods

	private func stupView() {
		configValidationVM()
		importsecretPhradseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseViewVM)
		view = importsecretPhradseView
	}

	func configValidationVM() {
		validationSecretPhraseViewVM = ValidateSecretPhraseVM(onSuccess: {
			self.importWallet()
		}, onFailure: { validationError in
			switch validationError {
			case .invalidSecretPhrase:
				self.importsecretPhradseView?.showError()
			}
		})
	}

	private func importWallet() {
		// Wallet should be verified here
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
