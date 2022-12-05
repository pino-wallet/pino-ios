//
//  ImportWalletViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/22/22.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: PublicProperties

	public var importsecretPhraseView: ImportSecretPhraseView?
	public var validationSecretPhraseViewVM: ValidateSecretPhraseViewModel!

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		setSteperView(stepsCount: 2, curreuntStep: 1)
		setupNavigationBackButton()
	}

	// MARK: Private Methods

	private func stupView() {
        configValidationVM()
		importsecretPhraseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseViewVM)
        addButtonsAction()
        view = importsecretPhraseView
	}

	func configValidationVM() {
		validationSecretPhraseViewVM = ValidateSecretPhraseViewModel(onSuccess: {
			self.importWallet()
		}, onFailure: { validationError in
			switch validationError {
			case .invalidSecretPhrase:
				self.importsecretPhraseView?.showError()
			}
		})
	}

	private func importWallet() {
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}

	private func addButtonsAction() {
		importsecretPhraseView?.importButton.addAction(UIAction(handler: { _ in
			self.validationSecretPhraseViewVM
				.validate(secretPhrase: self.importsecretPhraseView?.seedPhrasetextView.seedPhraseArray ?? [""])
		}), for: .touchUpInside)
	}
}
