//
//  AllDoneViewController.swift
//  Pino-iOS
//
//  Created by Mohi Raoufi on 11/19/22.
//

import UIKit

class AllDoneViewController: UIViewController {
	// MARK: View Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func loadView() {
		stupView()
		removeNavigationBackButton()
	}

	// MARK: Private Methods

	private func stupView() {
		let allDoneView = AllDoneView {
			self.getStarted()
		}
		view = allDoneView
	}

	private func getStarted() {
		// Go to homepage
	}
}
