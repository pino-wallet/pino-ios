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
		case .Import:
			let importWalletVC = ImportNewAccountViewController()
			importWalletVC.newAccountDidImport = { privateKey in
				self.importAccountWithKey(privateKey) { error in
					if let error {
						importWalletVC.importAccountView.activateButton()
						Toast.default(title: error.localizedDescription, style: .error).show(haptic: .warning)
					} else {
						self.dismiss(animated: true)
					}
				}
			}
			navigationController?.pushViewController(importWalletVC, animated: true)
		}
	}

	private func importAccountWithKey(_ privateKey: String, completion: @escaping (WalletOperationError?) -> Void) {
		accountsVM.importAccountWith(privateKey: privateKey) { error in
			if let error {
				completion(error)
			} else {
				completion(nil)
			}
		}
	}

	private func setupBindings() {
		addNewAccountVM.$AddNewAccountOptions.sink { [weak self] _ in
			self?.addNewAccountCollectionView.reloadData()
		}.store(in: &cancellables)
	}
}
