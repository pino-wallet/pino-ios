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
			let createWalletVC = ShowSecretPhraseViewController()
			createWalletVC.isNewWallet = true
			createWalletVC.addedNewWallet = {
				self.updateWallets()
			}
			navigationController?.pushViewController(createWalletVC, animated: true)
		case .Import:
			let importWalletVC = ImportSecretPhraseViewController()
			importWalletVC.isNewWallet = true
			importWalletVC.addedNewWallet = {
				self.updateWallets()
			}
			navigationController?.pushViewController(importWalletVC, animated: true)
		}
	}

	private func updateWallets() {
		addNewWalletVM.addNewWallet()
		walletsVM.getWallets()
	}
}
