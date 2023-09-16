//
//  ImportAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Combine
import UIKit

class ImportAccountsViewController: UIViewController {
	// MARK: - Private Properties

	private var importAccountsVM: ImportAccountsViewModel
	private var importAccountsView: ImportAccountsView!
	private var importLoadingView = ImportAccountLoadingView()

	// MARK: - Initializers

	init(walletMnemonics: String) {
		self.importAccountsVM = ImportAccountsViewModel(walletMnemonics: walletMnemonics)
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
		setSteperView(stepsCount: 3, curreuntStep: 2)
	}

	// MARK: - Private Methods

	private func setupView() {
		importAccountsView = ImportAccountsView(
			accountsVM: importAccountsVM,
			importButtonDidTap: {
				self.openPasscodePage()
			},
			findMoreAccountsDidTap: {
				self.importAccountsVM.findMoreAccounts {}
			}
		)
		view = importLoadingView
		importAccountsVM.getAccounts {
			self.view = self.importAccountsView
		}
	}

	private func openPasscodePage() {
		let createPasscodeViewController = CreatePasscodeViewController()
		createPasscodeViewController.pageSteps = 3
		createPasscodeViewController.walletMnemonics = importAccountsVM.walletMnemonics
		navigationController?.pushViewController(createPasscodeViewController, animated: true)
	}
}
