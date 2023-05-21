//
//  CreateImportViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/15/23.
//

import UIKit

class AddNewAccountViewController: UIViewController {
	// MARK: - Private Properties

	private let addNewAccountVM = AddNewAccountViewModel()
	private let accountsVM: AccountsViewModel
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Initializers

	init(accountsVM: AccountsViewModel) {
		self.accountsVM = accountsVM
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		setupNavigationBar()
	}

	// MARK: - Private Methods

	private func setupView() {
		view = AddNewAccountCollectionView(
            addNewAccountVM: addNewAccountVM,
            openAddNewAccountPageClosure: { [weak self] option in
				self?.openAddNewAccountPage(option: option)
			}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()

		setNavigationTitle(addNewAccountVM.pageTitle)
	}

	private func openAddNewAccountPage(option: AddNewAccountOptionModel) {
		switch option.page {
		case .Create:
			// New Wallet should be created
			// Loading should be shown
			// Homepage in the new account should be opened
			let coreDataManager = CoreDataManager()
			let currentWallet = coreDataManager.getSelectedWalletOf(type: .hdWallet)!
			let createdAccount = pinoWalletManager.createAccount(lastAccountIndex: Int(currentWallet.lastDrivedIndex))
            
			accountsVM.activateNewAccountAddress(
				createdAccount.eip55Address,
				derivationPath: createdAccount.derivationPath
			) {
				self.dismiss(animated: true)
			}
		case .Import:
			let importWalletVC = ImportSecretPhraseViewController()
			importWalletVC.isNewWallet = false
			importWalletVC.addedNewWalletWithPrivateKey = { privateKey in
				self.importAccountWithKey(privateKey)
			}
			navigationController?.pushViewController(importWalletVC, animated: true)
		}
	}

	private func importAccountWithKey(_ privateKey: String) {
		let importedAccount = pinoWalletManager.importAccount(privateKey: privateKey)
		switch importedAccount {
		case let .success(account):
			accountsVM.activateNewAccountAddress(account.eip55Address) {
				self.dismiss(animated: true)
			}
		case let .failure(error):
			fatalError(error.localizedDescription)
		}
	}
}
