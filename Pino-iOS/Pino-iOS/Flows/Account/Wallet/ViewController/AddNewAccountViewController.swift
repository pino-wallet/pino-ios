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
	private let createAccountFailedErr = "Failed to create account"

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
			self.accountsVM.importAccount(privateKey: privateKey, accountName: accountName, accountAvatar: avatar)
				.done {
					self.openSyncPage()
				}.catch { error in
					self.showErrorToast(error)
					importWalletVC.showValidationError(error)
				}
		}
		navigationController?.pushViewController(importWalletVC, animated: true)
	}

	private func openSyncPage() {
		let syncPage = SyncWalletViewController {
			self.onDismiss()
		}
		syncPage.modalPresentationStyle = .fullScreen
		present(syncPage, animated: true)
	}

	private func createNewAccount() {
		// New Wallet should be created
		// Loading should be shown
		// Homepage in the new account should be opened
		addNewAccountVM.setLoadingStatusFor(optionType: .Create, loadingStatus: true)
		accountsVM.createNewAccount().done {
			self.dismiss(animated: true)
		}.catch { [self] error in
			showErrorToast(error)
			addNewAccountVM.setLoadingStatusFor(optionType: .Create, loadingStatus: false)
		}
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? APIError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}

	private func setupBindings() {
		addNewAccountVM.$AddNewAccountOptions.sink { [weak self] _ in
			self?.addNewAccountCollectionView.reloadData()
		}.store(in: &cancellables)
	}
}
