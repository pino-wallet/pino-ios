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
	private let profileVM: ProfileViewModel
	private let hasDismiss: Bool
	private let hapticManager = HapticManager()
	private var onDismiss: () -> Void

	// MARK: Initializers

	init(
		accountsVM: AccountsViewModel,
		profileVM: ProfileViewModel,
		hasDismiss: Bool = false,
		onDismiss: @escaping (() -> Void)
	) {
		self.accountsVM = accountsVM
		self.onDismiss = onDismiss
		self.profileVM = profileVM
		self.hasDismiss = hasDismiss
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

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent, transitionCoordinator?.isInteractive == false {
			// code here
			hapticManager.run(type: .selectionChanged)
		}
	}

	// MARK: - Private Methods

	private func setupView() {
		view = AccountsCollectionView(
			accountsVM: accountsVM,
			profileVM: profileVM,
			editAccountTapped: { selectedAccount in
				self.openEditAccountPage(selectedAccount: selectedAccount)
			},
			dismissPage: { [weak self] in
				self?.dismiss(animated: true)
			}
		)
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()
		if hasDismiss {
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				image: UIImage(named: "dismiss"),
				style: .plain,
				target: self,
				action: #selector(dismissSelf)
			)
		}
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
		hapticManager.run(type: .lightImpact)
		let editAccountVM = EditAccountViewModel(selectedAccount: selectedAccount)
		let editAccountVC = EditAccountViewController(accountsVM: accountsVM, editAccountVM: editAccountVM)
		if navigationController?.viewControllers.last is AccountsViewController {
			navigationController?.pushViewController(editAccountVC, animated: true)
		}
	}

	@objc
	private func openCreateImportWalletPage() {
		hapticManager.run(type: .selectionChanged)
		let createImportWalletVC = AddNewAccountViewController(accountsVM: accountsVM, onDismiss: onDismiss)
		navigationController?.pushViewController(createImportWalletVC, animated: true)
	}

	@objc
	private func dismissSelf() {
		hapticManager.run(type: .selectionChanged)
		dismiss(animated: true)
	}
}
