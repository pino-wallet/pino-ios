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
	private let selectedAccounts: [ActiveAccountViewModel]

	// MARK: - Initializers

	init(selectedAccounts: [ActiveAccountViewModel]) {
		self.selectedAccounts = selectedAccounts
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
		allDoneVM.importSelectedAccounts(selectedAccounts: selectedAccounts) { error in
			if let error {
				Toast.default(title: error.description, style: .error).show(haptic: .warning)
				self.allDoneView.activeGetStartedButton()
			} else {
				UserDefaults.standard.set(true, forKey: "isLogin")
				let tabBarVC = TabBarViewController()
				tabBarVC.modalPresentationStyle = .fullScreen
				self.present(tabBarVC, animated: true)
			}
		}
	}
}
