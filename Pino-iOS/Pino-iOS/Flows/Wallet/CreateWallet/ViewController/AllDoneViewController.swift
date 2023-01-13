//
//  AllDoneViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import UIKit

class AllDoneViewController: UIViewController {
	// MARK: Private Properties

	private let allDoneVM = AllDoneViewModel()

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
		let allDoneView = AllDoneView(allDoneVM: allDoneVM) {
			self.getStarted()
		}
		view = allDoneView
	}

	private func getStarted() {
		UserDefaults.standard.set(true, forKey: "isLogin")
		let tabBarVC = TabBarViewController()
		tabBarVC.modalPresentationStyle = .fullScreen
		present(tabBarVC, animated: true)
	}
}
