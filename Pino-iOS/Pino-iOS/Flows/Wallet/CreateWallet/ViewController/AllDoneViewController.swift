//
//  AllDoneViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import Combine
import UIKit

class AllDoneViewController: UIViewController {
	// MARK: - Private Properties

	private var allDoneVM: AllDoneViewModel
	private var allDoneView: AllDoneView!
	private var selectedAccounts: [ActiveAccountViewModel]?
	private var mnemonics: String

	// MARK: - Initializers

	init(selectedAccounts: [ActiveAccountViewModel]?, mnemonics: String) {
		self.selectedAccounts = selectedAccounts
		self.mnemonics = mnemonics
		self.allDoneVM = AllDoneViewModel(mnemonics: mnemonics)
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
		removeNavigationBackButton()
	}

	// MARK: - Private Methods

	private func setupView() {
		allDoneView = AllDoneView(allDoneVM: allDoneVM, getStarted: {
			self.getStarted()
		})
		view = allDoneView
	}

	private func getStarted() {
		if let selectedAccounts {
			allDoneVM.importSelectedAccounts(selectedAccounts: selectedAccounts).done {
				self.openHomepage()
			}.catch { error in
				self.showError(error)
			}
		} else {
			allDoneVM.createWallet(mnemonics: mnemonics).done {
				self.openHomepage()
			}.catch { error in
				// this is wrong
				self.showError(error)
			}
		}
	}

	private func showError(_ error: Error) {
		if let error = error as? APIError {
			Toast.default(title: error.toastMessage, style: .error).show()
		}
		allDoneView.activeGetStartedButton()
	}

	private func openHomepage() {
		UserDefaultsManager.isUserLoggedIn.setValue(value: true)
		let tabBarVC = TabBarViewController()
		tabBarVC.modalPresentationStyle = .fullScreen
		present(tabBarVC, animated: true)
	}
}
