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
	public var newAccountDidImport: ((_ privateKey: String, _ avatar: Avatar, _ accountName: String) -> Void)!

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
			importBtnTapped: { [unowned self] in
				self.importWallet()
			}
		)
		view = importAccountView
	}

	private func importWallet() {
		let privateKey = importAccountView.textViewText
		importAccountVM.validateWalletAccount(
			privateKey: privateKey,
			onSuccess: { [weak self] in
				guard let self else { return }
				newAccountDidImport(privateKey, importAccountVM.accountAvatar, importAccountVM.accountName)
			},
			onFailure: { validationError in
				self.showValidationError()
			}
		)
	}

	private func showValidationError() {
		importAccountView?.showError()
		importAccountView?.activateButton()
	}
}
