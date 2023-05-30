//
//  AllDoneViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import UIKit

class AllDoneViewController: UIViewController {
	// MARK: Private Properties

	private let errorToastView = PinoToastView(message: nil, style: .error, padding: 95)
	private var allDoneVM = AllDoneViewModel()
	private var allDoneView: AllDoneView!

	// MARK: Public Properties

	public var walletMnemonics: String!

	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		setupView()
		removeNavigationBackButton()
	}

	// MARK: Private Methods

	private func setupView() {
		allDoneView = AllDoneView(allDoneVM: allDoneVM) {
			self.getStarted()
		}
		view = allDoneView
	}

	private func getStarted() {
		allDoneVM.createWallet(mnemonics: walletMnemonics) { error in
			if let error {
				self.errorToastView.message = error.description
				self.errorToastView.showToast()
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
