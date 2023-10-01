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

	private var allDoneVM = AllDoneViewModel()
	private var allDoneView: AllDoneView!
	private var selectedAccounts: [ActiveAccountViewModel]?
	private var mnemonics: String?

	// MARK: - Initializers

	init(selectedAccounts: [ActiveAccountViewModel]?, mnemonics: String?) {
		self.selectedAccounts = selectedAccounts
		self.mnemonics = mnemonics
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
		allDoneView = AllDoneView(allDoneVM: allDoneVM) {
			self.getStarted()
		}
		view = allDoneView
	}

	private func getStarted() {
		if let selectedAccounts {
			allDoneVM.importSelectedAccounts(selectedAccounts: selectedAccounts) { error in
				if let error {
					self.showError(error)
				} else {
					self.openHomepage()
				}
			}
		} else if let mnemonics {
			allDoneVM.createWallet(mnemonics: mnemonics) { error in
				if let error {
					self.showError(error)
				} else {
					self.openHomepage()
				}
			}
		}
	}

	private func showError(_ error: WalletOperationError) {
		Toast.default(title: error.description, style: .error).show(haptic: .warning)
		allDoneView.activeGetStartedButton()
	}

	private func openHomepage() {
		UserDefaults.standard.set(true, forKey: "isLogin")
		let tabBarVC = TabBarViewController()
		tabBarVC.modalPresentationStyle = .fullScreen
		present(tabBarVC, animated: true)
	}
}
