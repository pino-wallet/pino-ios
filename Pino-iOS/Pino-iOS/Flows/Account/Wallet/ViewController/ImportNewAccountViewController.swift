//
//  ImportNewAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 3/3/24.
//

import UIKit

class ImportNewAccountViewController: UIViewController {
	// MARK: - PublicProperties

	public var importAccountView: ImportNewAccountView!
	public var importAccountVM = ImportNewAccountViewModel()
	public var newAccountDidImport: ((String) -> Void)!

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupPrimaryColorNavigationBar()
		setNavigationTitle(importAccountVM.pageTitle)
	}

	// MARK: - Private Methods

	private func setupView() {
		importAccountView = ImportNewAccountView(
			importAccountVM: importAccountVM,
			textViewType: PrivateKeyTextView(),
			importBtnTapped: { [unowned self] in
				self.importWallet()
			}
		)
		view = importAccountView
	}

	private func importWallet() {
		let privateKey = importAccountView.textViewText
		importAccountVM.validate(
			privateKey: privateKey,
			onSuccess: {
				self.newAccountDidImport(privateKey)
			},
			onFailure: { validationError in
				self.showValidationError(validationError)
			}
		)
	}

	private func showValidationError(_ error: SecretPhraseValidationError) {
		switch error {
		case .invalidSecretPhrase:
			importAccountView?.showError()
			importAccountView?.activateButton()
		}
	}
}
