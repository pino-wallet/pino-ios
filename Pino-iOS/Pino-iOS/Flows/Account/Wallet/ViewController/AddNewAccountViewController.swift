//
//  CreateImportViewController.swift
//  Pino-iOS
//
//  Created by Amir Kazemi on 3/15/23.
//

import Combine
import PromiseKit
import UIKit

class AddNewAccountViewController: UIViewController {
	// MARK: - Private Properties

	private let accountsVM: AccountsViewModel
    private let hapticManager = HapticManager()
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
			openCreateAccountPage()
		case .Import:
			openImportAccountPage()
		}
	}

	private func openImportAccountPage() {
        hapticManager.run(type: .mediumImpact)
		let importWalletVC = ImportNewAccountViewController(accounts: accountsVM.accountsList)
		importWalletVC.newAccountDidImport = { privateKey, avatar, accountName in
			self.accountsVM.importAccount(privateKey: privateKey, accountName: accountName, accountAvatar: avatar)
				.done {
					self.openSyncPage()
				}.catch { error in
					importWalletVC.showValidationError(error)
				}
		}
		navigationController?.pushViewController(importWalletVC, animated: true)
	}

	private func openCreateAccountPage() {
        hapticManager.run(type: .mediumImpact)
		let createWalletVC = CreateNewAccountViewController(accounts: accountsVM.accountsList)
		createWalletVC.newAccountDidCreate = { avatar, accountName in
			self.createNewAccount(accountName: accountName, accountAvatar: avatar).done {
				self.onDismiss()
			}.catch { error in
				createWalletVC.showValidationError(error)
			}
		}
		navigationController?.pushViewController(createWalletVC, animated: true)
	}

	private func openSyncPage() {
		let syncPage = SyncWalletViewController {
			self.onDismiss()
		}
		syncPage.modalPresentationStyle = .fullScreen
		present(syncPage, animated: true)
	}

	private func createNewAccount(accountName: String, accountAvatar: Avatar) -> Promise<Void> {
		Promise<Void> { seal in
			accountsVM.createNewAccount(accountName: accountName, accountAvatar: accountAvatar).done {
				seal.fulfill(())
			}.catch { [self] error in
				if let error = error as? WalletError {
					switch error {
					case .accountAlreadyExists:
						accountsVM.createNewAccountWithNextIndex(
							accountName: accountName,
							accountAvatar: accountAvatar
						).done {
							seal.fulfill(())
						}.catch { error in
							seal.reject(error)
						}
					default:
						seal.reject(error)
					}
				} else {
					seal.reject(error)
				}
			}
		}
	}

	private func showErrorToast(_ error: Error) {
		if let error = error as? ToastError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
	}

	private func setupBindings() {
		addNewAccountVM.$AddNewAccountOptions.sink { [weak self] _ in
			self?.addNewAccountCollectionView.reloadData()
		}.store(in: &cancellables)
	}
}
