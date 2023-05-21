//
//  WalletsViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 2/13/23.
//

import UIKit

class AccountsViewController: UIViewController {
	// MARK: Private Properties

	private let accountsVM: AccountsViewModel

	// MARK: Initializers

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
		view = AccountsCollectionView(accountsVM: accountsVM, editAccountTapped: { selectedAccount in
			self.openEditAccountPage(selectedAccount: selectedAccount)
		})
	}

	private func setupNavigationBar() {
		// Setup title view
		setNavigationTitle("Wallets")
		// Setup add asset button
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "plus"),
			style: .plain,
			target: self,
			action: #selector(openCreateImportWalletPage)
		)
	}

	private func openEditAccountPage(selectedAccount: AccountInfoViewModel) {
        let editAccountVM = EditAccountViewModel(selectedAccount: selectedAccount)
		let editAccountVC = EditAccountViewController(accountsVM: accountsVM, editAccountVM: editAccountVM)
		if navigationController?.viewControllers.last is AccountsViewController {
			navigationController?.pushViewController(editAccountVC, animated: true)
		}
	}

	@objc
	private func openCreateImportWalletPage() {
		let createImportWalletVC = AddNewAccountViewController(accountsVM: accountsVM)
		navigationController?.pushViewController(createImportWalletVC, animated: true)
	}
}
