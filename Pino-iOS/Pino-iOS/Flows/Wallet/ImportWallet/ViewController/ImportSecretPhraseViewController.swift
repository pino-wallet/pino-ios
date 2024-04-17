//
//  ImportSecretPhraseViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/5/23.
//

import UIKit

class ImportSecretPhraseViewController: UIViewController {
	// MARK: - PublicProperties

	public var importsecretPhraseView: ImportSecretPhraseView!
	public var importAccountVM = ImportSecretPhraseViewModel()

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setSteperView(stepsCount: 3, curreuntStep: 1)
	}

	// MARK: - Private Methods

	private func setupView() {
		importsecretPhraseView = ImportSecretPhraseView(
			validationPharaseVM: importAccountVM,
			importBtnTapped: { [unowned self] in
				importWallet()
			}
		)
		view = importsecretPhraseView
	}

	private func importWallet() {
		let trimmedMnemonic = importAccountVM.trimmedMnemonic(importsecretPhraseView.textViewText)
		importAccountVM.validate(
			secretPhrase: trimmedMnemonic,
			onSuccess: {
				self.openAccountsPage(mnemonics: trimmedMnemonic)
			},
			onFailure: { validationError in
				self.showValidationError()
			}
		)
	}

	private func openAccountsPage(mnemonics: String) {
		let importAccountsVC = ImportAccountsViewController(walletMnemonics: mnemonics)
		navigationController?.pushViewController(importAccountsVC, animated: true)
	}

	private func showValidationError() {
		importsecretPhraseView?.showError()
		importsecretPhraseView?.activateButton()
	}
}
