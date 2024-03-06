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
		setSteperView(stepsCount: 4, curreuntStep: 2)
	}

	// MARK: - Private Methods

	private func setupView() {
		importAccountsView = ImportAccountsView(
			accountsVM: importAccountsVM,
			importButtonDidTap: {
				self.openPasscodePage()
			},
			findMoreAccountsDidTap: {
				self.importAccountsVM.findMoreAccounts().catch { error in
					Toast.default(title: "Failed to fetch accounts", style: .error).show(haptic: .success)
				}
			}
		)
		view = importLoadingView
		importAccountsVM.getFirstAccounts().done { _ in
			self.view = self.importAccountsView
		}.catch { error in
			Toast.default(title: "Failed to fetch accounts", style: .error).show(haptic: .success)
		}
	}

	private func openPasscodePage() {
		let selectedAccounts = importAccountsVM.accounts.filter { $0.isSelected }
		if !selectedAccounts.isEmpty {
			let createPasscodeViewController = CreatePasscodeViewController(
				selectedAccounts: selectedAccounts,
				mnemonics: importAccountsVM.walletMnemonics
			)
			createPasscodeViewController.pageSteps = 4
			createPasscodeViewController.currentStep = 3
			navigationController?.pushViewController(createPasscodeViewController, animated: true)
		}
	}
}
