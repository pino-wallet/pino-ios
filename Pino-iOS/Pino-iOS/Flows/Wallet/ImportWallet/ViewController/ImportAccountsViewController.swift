//
//  ImportAccountViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 9/13/23.
//

import Combine
import PromiseKit
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

	override func viewWillDisappear(_ animated: Bool) {
		importLoadingView.findingAccountLottieAnimationView.animation = nil
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
				self.importAccountsVM.findMoreAccounts().catch { error in
					self.showErrorToast(ImportAccountsError.fetchActiveAccount)
				}
			}
		)
		view = importLoadingView
		importAccountsVM.getFirstAccounts().done { [weak self] _ in
			if self?.navigationController?.topViewController == self {
				self?.view = self?.importAccountsView
			}
		}.catch { error in
			self.showErrorToast(ImportAccountsError.fetchActiveAccount)
		}
	}

	private func openPasscodePage() {
		importAccountsVM.startSync().done { [unowned self] in
			importAccountsView.stopLoading()
			let selectedAccounts = importAccountsVM.accounts.filter { $0.isSelected }
			if !selectedAccounts.isEmpty {
				let createPasscodeViewController = CreatePasscodeViewController(
					selectedAccounts: selectedAccounts,
					mnemonics: importAccountsVM.walletMnemonics
				)
				createPasscodeViewController.pageSteps = 3
				createPasscodeViewController.currentStep = 3
				navigationController?.pushViewController(createPasscodeViewController, animated: true)
			}
		}.catch { error in
			self.importAccountsView.stopLoading()
			self.showErrorToast(ImportAccountsError.importAccount)
		}
	}

	private func showErrorToast(_ error: Error) {
		guard let error = error as? ToastError else { return }
		Toast.default(title: error.toastMessage, style: .error).show(haptic: .success)
	}
}
