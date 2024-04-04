//
//  CreateImportViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/15/23.
//

import Combine
import UIKit

class AddNewAccountViewController: UIViewController {
	// MARK: - Private Properties

	private let accountsVM: AccountsViewModel
	private var addNewAccountCollectionView: AddNewAccountCollectionView!
	private var addNewAccountVM = AddNewAccountViewModel()
	private var cancellables = Set<AnyCancellable>()
	private var onDismiss: () -> Void

	// MARK: - Initializers

	init(accountsVM: AccountsViewModel, onDismiss: @escaping (() -> Void)) {
		self.accountsVM = accountsVM
		self.onDismiss = onDismiss
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
		setupBindings()
	}

	// MARK: - Private Methods

	private func setupView() {
		addNewAccountCollectionView = AddNewAccountCollectionView(
			addNewAccountVM: addNewAccountVM,
			openAddNewAccountPageClosure: { [weak self] option in
				self?.openAddNewAccountPage(option: option)
			}
		)
		view = addNewAccountCollectionView
	}

	private func setupNavigationBar() {
		setupPrimaryColorNavigationBar()

		setNavigationTitle(addNewAccountVM.pageTitle)
	}

	private func openAddNewAccountPage(option: AddNewAccountOptionModel) {
		switch option.type {
		case .Create:
			createNewAccount()
		case .Import:
			openImportAccountPage()
		}
	}

	private func openImportAccountPage() {
		let importWalletVC = ImportNewAccountViewController(accounts: accountsVM.accountsList)
		importWalletVC.newAccountDidImport = { privateKey, avatar, accountName in
			self.importAccount(privateKey: privateKey, avatar: avatar, accountName: accountName) { error in
				if let error {
					importWalletVC.showValidationError(error)
				} else {
					self.openSyncPage()
				}
			}
		}
		navigationController?.pushViewController(importWalletVC, animated: true)
	}

	private func importAccount(
		privateKey: String,
		avatar: Avatar,
		accountName: String,
		completion: @escaping (WalletOperationError?) -> Void
	) {
		accountsVM.importAccount(privateKey: privateKey, accountName: accountName, accountAvatar: avatar) { error in
			if let error {
				completion(error)
			} else {
				completion(nil)
			}
		}
	}

	private func openSyncPage() {
		let syncPage = SyncWalletViewController {
			self.onDismiss()
		}
		syncPage.modalPresentationStyle = .overFullScreen
		present(syncPage, animated: true)
	}

	private func createNewAccount() {
		// New Wallet should be created
		// Loading should be shown
		// Homepage in the new account should be opened
		addNewAccountVM.setLoadingStatusFor(optionType: .Create, loadingStatus: true)
		accountsVM.createNewAccount { [weak self] error in
			if let error {
				Toast.default(title: error.description, style: .error).show(haptic: .warning)
				self?.addNewAccountVM.setLoadingStatusFor(optionType: .Create, loadingStatus: false)
				return
			} else {
				self?.dismiss(animated: true)
			}
		}
	}

	private func setupBindings() {
		addNewAccountVM.$AddNewAccountOptions.sink { [weak self] _ in
			self?.addNewAccountCollectionView.reloadData()
		}.store(in: &cancellables)
	}
}
