//
//  ImportSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/5/23.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: PublicProperties

	public var importsecretPhraseView: ImportSecretPhraseView!
	public var validationSecretPhraseVM: ValidateSecretPhraseViewModel!
	public var showSteperView = true

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		if showSteperView {
			setSteperView(stepsCount: 2, curreuntStep: 1)
		} else {
			setupPrimaryColorNavigationBar()
		}
	}

	// MARK: Private Methods

	private func setupView() {
		validationSecretPhraseVM = ValidateSecretPhraseViewModel()
		importsecretPhraseView = ImportSecretPhraseView(validationPharaseVM: validationSecretPhraseVM)
		addButtonsAction()
		view = importsecretPhraseView
	}

	private func addButtonsAction() {
		importsecretPhraseView.importButton.addAction(UIAction(handler: { _ in
			self.validationSecretPhraseVM.validate(
				secretPhrase: self.importsecretPhraseView.seedPhrasetextView.seedPhraseArray,
				onSuccess: {
					self.importWallet()
				},
				onFailure: { validationError in
					switch validationError {
					case .invalidSecretPhrase:
						self.importsecretPhraseView?.showError()
					}
				}
			)
		}), for: .touchUpInside)
	}

	private func importWallet() {
		// Go to create passcode page
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 2
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
