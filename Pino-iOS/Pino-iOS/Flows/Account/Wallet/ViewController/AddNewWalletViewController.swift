//
//  CreateImportViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/15/23.
//

import UIKit

class AddNewWalletViewController: UIViewController {
	// MARK: - Private Properties

	private let addNewWalletVM = AddNewWalletViewModel()
	private let walletsVM: WalletsViewModel
	private let pinoWalletManager = PinoWalletManager()

	// MARK: - Initializers

	init(walletsVM: WalletsViewModel) {
		self.walletsVM = walletsVM
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
		view = AddNewWalletCollectionView(
			addNewWalletVM: addNewWalletVM,
			openAddNewWalletPageClosure: { [weak self] option in
				self?.openAddNewWalletPage(option: option)
			}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()

		setNavigationTitle(addNewWalletVM.pageTitle)
	}

	private func openAddNewWalletPage(option: AddNewWalletOptionModel) {
		switch option.page {
		case .Create:
			// New Wallet should be created
			// Loading should be shown
			// Homepage in the new account should be opened
			print("new wallet tapped")
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
			addNewWalletVM.addNewWalletWithAddress(account.eip55Address)
			walletsVM.getWallets()
		case let .failure(error):
			fatalError(error.localizedDescription)
		}
	}
}
