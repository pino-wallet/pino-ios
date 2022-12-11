//
//  ImportSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 12/11/22.
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
	}

	// MARK: Private Methods

	private func stupView() {
		validationSecretPhraseViewVM = ValidateSecretPhraseViewModel()
		importsecretPhraseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseViewVM)
		addButtonsAction()
		view = importsecretPhraseView
	}

	private func addButtonsAction() {
		importsecretPhraseView?.importButton.addAction(UIAction(handler: { _ in
			self.validationSecretPhraseViewVM
				.validate(secretPhrase: self.importsecretPhraseView?.seedPhrasetextView.seedPhraseArray ?? [""]) {
					self.importWallet()
				} onFailure: { validationError in
					switch validationError {
					case .invalidSecretPhrase:
						self.importsecretPhraseView?.showError()
					}
				}

		}), for: .touchUpInside)
	}

	private func importWallet() {
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
